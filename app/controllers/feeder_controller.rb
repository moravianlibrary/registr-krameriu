require 'open-uri'
require 'net/http'
require 'net/https'
require 'json'
class FeederController < ApplicationController
	 before_action :set_cache_headers
	 before_action :ensure_login, only: [:reset_clients]

	def single_library
	  code = params[:code]
	  library = Library.find_by(code: code)
		if library.nil?
			render plain: "library with code #{code} not found"
	  else
	    update_library(library)
	    redirect_to library, notice: 'Načtení dat dokončeno'
	  end
	end

	def all
		Library.all.each do |library|
			update_library(library)
		end
		Helper.destroy_all
		Helper.create(last_update:Time.now)
		render plain: "ok"
		#redirect_to libraries_path, notice: 'Načtení dat dokončeno'
	end

	def ping
		render plain: "ok"
	end

	def reset_clients
		Library.all.each do |l|
		  if l.integer_version > 511
		    l.update_attributes(alt_client_universal: true)
		  end
		  if l.integer_version > 502
		    l.update_attributes(ios: 2, android: 2)
		  end
		end
		render plain: "ok"
	end

	private

		def update_library(library)
			if library.new_client_url
				client_version = "-"
				t = get_text(library.new_client_url)
				if t
					vv = t.match(/\/globals.js\?v(.*)\"/)
					if vv
						client_version = vv[1]
					end
				end
				library.new_client_version = client_version
			else
				library.new_client_version = nil
			end
			base_url = library.search_url
			api_url = base_url + "api/v5.0/"
			api_url = library.url + "/catalogue/" if library.code == 'snk'
			info = get_json(api_url + "info")
			# library.alive = false
			alive = false
			if !info || (info["version"] && info["version"].start_with?("7"))
				api_url = base_url + "api/client/v7.0/"
				info = get_json(api_url + "info")
				if info
					library.version = info["version"]
					library.email = info["email"]
					library.right_msg = info["rightMsg"]
					library.pdf_max = info["pdfMaxRange"]
					# library.alive = true
					updateK7(library, api_url)
					return
				end
			end

			if info
				library.version = info["version"]
				library.email = info["email"]
				library.intro = info["intro"]
				library.right_msg = info["rightMsg"]
				library.pdf_max = info["pdfMaxRange"]
				# library.alive = true
				alive = true
			end
			if !info
				t = get_text(base_url)
				if t
					vv = t.match(/version: (.*), /)
					if vv
						library.version = vv[1]
						# library.alive = true
						alive = true
					end
				end
			end
			library.save and return if !alive

			vc = get_json(api_url + "vc")
			library.collections = vc.length unless vc.nil?

			# k5_status = get_status(library.client_url)
			# puts "k5 client status code: #{k5_status}"
			# if k5_status == '200'
			# 	puts "setting k5 client to true"
			# 	library.k5_client = true
			# end


			custom = get_json(api_url + "feed/custom")
			c_all = 0
			c_public = 0
			if custom
				all = custom["data"]
				if all
					all.each do |c|
						c_all += 1
						if c["policy"] == 'public'
							c_public += 1
						end
					end
				end
				library.recommended = c_all
				library.recommended_public = c_public
			end


			search_all_url = api_url + "search?q=(fedora.model:monograph%20OR%20fedora.model:periodical%20OR%20fedora.model:soundrecording%20OR%20fedora.model:map%20OR%20fedora.model:graphic%20OR%20fedora.model:sheetmusic%20OR%20fedora.model:convolute%20OR%20fedora.model:archive%20OR%20fedora.model:manuscript)&rows=0"
			search_public_url = api_url + "search?q=(fedora.model:monograph%20OR%20fedora.model:periodical%20OR%20fedora.model:soundrecording%20OR%20fedora.model:map%20OR%20fedora.model:graphic%20OR%20fedora.model:sheetmusic%20OR%20fedora.model:convolute%20OR%20fedora.model:archive%20OR%20fedora.model:manuscript)%20AND%20dostupnost:public&rows=0"
			all_docs = get_json(search_all_url)
			begin
				library.documents_all = all_docs["response"]["numFound"]
			rescue
			end
			public_docs = get_json(search_public_url)
			begin
				library.documents_public = public_docs["response"]["numFound"]
			rescue
			end

			last_doc = get_json(api_url + "search?fl=created_date&q=*:*&sort=created_date%20desc&rows=1")
			begin
				library.last_document_at = DateTime.parse(last_doc["response"]["docs"][0]["created_date"])
			rescue
			end

			available_models = [
				"monograph", "periodical", "soundrecording", "map", "graphic", "sheetmusic", "archive", "manuscript", "article", "periodicalitem", "supplement", "periodicalvolume", "monographunit", "track", "soundunit", "internalpart", "convolute", "picture", "page"
			]

			begin
				model_facets_url = api_url + "search?q=*:*&facet=true&facet.mincount=1&facet.field=fedora.model&rows=0"
				model_facets = get_json(model_facets_url)["facet_counts"]["facet_fields"]["fedora.model"]
				model_facets.each_with_index do |val, idx|
					next if idx % 2 == 1 || !available_models.include?(val)
					count = model_facets[idx + 1]
					prefix = val == "page" ? "pages" : "model_#{val}"
					library["#{prefix}_all"] = model_facets[idx + 1]
					# puts "A:#{prefix} -> #{model_facets[idx + 1]}"
				end

				model_facets_url = api_url + "search?q=dostupnost:public&facet=true&facet.mincount=1&facet.field=fedora.model&rows=0"
				model_facets = get_json(model_facets_url)["facet_counts"]["facet_fields"]["fedora.model"]
				model_facets.each_with_index do |val, idx|
					next if idx % 2 == 1 || !available_models.include?(val)
					count = model_facets[idx + 1]
					prefix = val == "page" ? "pages" : "model_#{val}"
					library["#{prefix}_public"] = model_facets[idx + 1]
					# puts "P:#{prefix} -> #{model_facets[idx + 1]}"
				end
			rescue
			end
			licenses = []
			begin
				license_facets_url = api_url + "search?q=fedora.model:page&facet=true&facet.mincount=1&facet.field=dnnt-labels&rows=0"
				license_facets = get_json(license_facets_url)["facet_counts"]["facet_fields"]["dnnt-labels"]
				license_facets.each_with_index do |val, idx|
					next if idx % 2 == 1
					count = license_facets[idx + 1]
					l = { id: val, count: count }
					licenses << l
				end
			rescue
			end
			library.licenses = licenses.to_json.to_s
			date = Date.current
			r = Record.where(library: library, date: date)
			if(r.blank?)
				r = Record.create(library: library, date: date, documents_all: library.documents_all, documents_public: library.documents_public, pages_all: library.pages_all, pages_public: library.pages_public, version: library.version)
				calc_inc(r)
			else
				r.first.update(documents_all: library.documents_all, documents_public: library.documents_public, pages_all: library.pages_all, pages_public: library.pages_public, version: library.version)
				calc_inc(r.first)
			end
			library.save
		end


		def updateK7(library, api_url)
			toplevel_models = [ "monograph", "periodical", "soundrecording", "map", "graphic", "sheetmusic", "archive", "manuscript", "convolute"]
			query = "(model:#{toplevel_models.join("%20OR%20model:")})"
			search_all_url = api_url + "search?q=#{query}&rows=0"
			search_public_url = api_url + "search?q=#{query}%20AND%20accessibility:public&rows=0"
			all_docs = get_json(search_all_url)
			begin
				library.documents_all = all_docs["response"]["numFound"]
			rescue
			end
			public_docs = get_json(search_public_url)
			begin
				library.documents_public = public_docs["response"]["numFound"]
			rescue
			end

			last_doc = get_json(api_url + "search?fl=created&q=*:*&sort=created%20desc&rows=1")
			begin
				library.last_document_at = DateTime.parse(last_doc["response"]["docs"][0]["created"])
			rescue
			end

			available_models = [
				"monograph", "periodical", "soundrecording", "map", "graphic", "sheetmusic", "archive", "manuscript", "article", "periodicalitem", "supplement", "periodicalvolume", "monographunit", "track", "soundunit", "internalpart", "convolute", "picture", "page"
			]
			begin
				model_facets_url = api_url + "search?q=*:*&facet=true&facet.mincount=1&facet.field=model&rows=0"
				model_facets = get_json(model_facets_url)["facet_counts"]["facet_fields"]["model"]
				model_facets.each_with_index do |val, idx|
					next if idx % 2 == 1 || !available_models.include?(val)
					count = model_facets[idx + 1]
					prefix = val == "page" ? "pages" : "model_#{val}"
					library["#{prefix}_all"] = model_facets[idx + 1]
					# puts "A:#{prefix} -> #{model_facets[idx + 1]}"
				end

				model_facets_url = api_url + "search?q=accessibility:public&facet=true&facet.mincount=1&facet.field=model&rows=0"
				model_facets = get_json(model_facets_url)["facet_counts"]["facet_fields"]["model"]
				model_facets.each_with_index do |val, idx|
					next if idx % 2 == 1 || !available_models.include?(val)
					count = model_facets[idx + 1]
					prefix = val == "page" ? "pages" : "model_#{val}"
					library["#{prefix}_public"] = model_facets[idx + 1]
					# puts "P:#{prefix} -> #{model_facets[idx + 1]}"
				end
			rescue
			end

			collections_url = api_url + "search?q=model:collection&rows=0"
			collections = get_json(collections_url)
			begin
				library.collections	 = collections["response"]["numFound"]
			rescue
			end

			licenses = []
			begin
				lmap = {}
				llist = []
				license_facets_url = api_url + "search?q=model:page&facet=true&facet.mincount=1&facet.field=licenses_of_ancestors&rows=0"
				license_facets = get_json(license_facets_url)["facet_counts"]["facet_fields"]["licenses_of_ancestors"]
				license_facets.each_with_index do |val, idx|
					next if idx % 2 == 1
					count = license_facets[idx + 1]
					lmap[val] = count
					llist << val
				end
				license_facets_url = api_url + "search?q=model:page&facet=true&facet.mincount=1&facet.field=licenses&rows=0"
				license_facets = get_json(license_facets_url)["facet_counts"]["facet_fields"]["licenses"]
				license_facets.each_with_index do |val, idx|
					next if idx % 2 == 1
					count = license_facets[idx + 1]
					if llist.include?(val)
						lmap[val] += count
					else
						lmap[val] = count
						llist << val
					end
				end
				llist.each do |l|
					licenses << { id: l, count: lmap[l] }
				end
			rescue
			end
			library.licenses = licenses.to_json.to_s
			date = Date.current
			r = Record.where(library: library, date: date)
			if(r.blank?)
				r = Record.create(library: library, date: date, documents_all: library.documents_all, documents_public: library.documents_public, pages_all: library.pages_all, pages_public: library.pages_public, version: library.version)
				calc_inc(r)
			else
				r.first.update(documents_all: library.documents_all, documents_public: library.documents_public, pages_all: library.pages_all, pages_public: library.pages_public, version: library.version)
				calc_inc(r.first)
			end
			library.save
		end


		def calc_inc(record)
			library = record.library
			last = library.records.where("date < ?", record.date).order(date: :desc).limit(1)
			if !last.blank?
				r = last[0]
				begin
					record.update(
						inc_documents_all: (record.documents_all - r.documents_all),
						inc_documents_public: (record.documents_public - r.documents_public),
						inc_pages_all: (record.pages_all - r.pages_all),
						inc_pages_public: (record.pages_public - r.pages_public),
						)
				rescue
				end
			end
		end


		def get_response(url)
			puts url
			uri = URI.parse(url)
			http = Net::HTTP.new(uri.host, uri.port)
			http.read_timeout = 10
			http.open_timeout = 10
			if uri.scheme == "https"
				http.use_ssl = true
				http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			end
			request = Net::HTTP::Get.new(uri, initheader = {'Content-Type' =>'application/json', 'Accept-Language' => 'cs-CZ', 'Accept' =>'application/json'})
			begin
				http.request(request)
			rescue Exception => e 
				puts "err #{e}"
			end
		end

		def get_text(url)
			response = get_response(url)
			if response.nil?
				return nil
			end
			status_code = response.code.to_i
			if status_code == 200
			  response.body
			else
			  nil
			end
		end

		def get_status(url)
			response = get_response(url)
			if !response.nil?
				response.code
			end
		end


		def get_json(url)
			begin
				JSON.parse(get_text(url))
			rescue
			end
		end

		def set_cache_headers
			response.headers["Cache-Control"] = "no-cache, no-store"
			response.headers["Pragma"] = "no-cache"
			response.headers["Expires"] = "Fri, 01 Jan 1990 00:00:00 GMT"
		end

end
