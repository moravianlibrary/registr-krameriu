require 'open-uri'
require 'net/http'
require 'net/https'
require 'json'
class FeederController < ApplicationController
	 before_filter :set_cache_headers
	 before_action :ensure_login, only: [:reset_clients]

	def library
	  code = params[:code]
	  library = Library.find_by(code: code)
	  if library.nil?
	  	render :text => "library with code #{code} not found",:content_type => "text/plain"
	  else
	    update_library(library)
	    redirect_to library, notice: 'Načtení dat dokončeno'
	    ##render :text => "ok",:content_type => "text/plain"
	  end
	end

	def all
		Library.all.each do |library|
			update_library(library)
		end
		Helper.destroy_all
		Helper.create(last_update:Time.now)
		render :text => "ok",:content_type => "text/plain"
		#redirect_to libraries_path, notice: 'Načtení dat dokončeno'
	end

	def ping
		render :text => "ok",:content_type => "text/plain"
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
		render :text => "ok",:content_type => "text/plain"
	end

	private

		def update_library(library)
			base_url = library.search_url
			api_url = base_url + "api/v5.0/"
			info = get_json(api_url + "info")
			if info
				library.version = info["version"]
				library.email = info["email"]
				library.intro = info["intro"]
				library.right_msg = info["rightMsg"]
				library.pdf_max = info["pdfMaxRange"]
			else
				t = get_text(base_url)
				if t
					vv = t.match(/version: (.*), /)
					if vv
						library.version = vv[1]
					end
				end
			end

			k5_status = get_status(library.client_url)
			puts "k5 client status code: #{k5_status}"
			if k5_status == '200'
				puts "setting k5 client to true"
				library.k5_client = true
			end


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


			search_all_url = api_url + "search?q=(fedora.model:monograph%20OR%20fedora.model:periodical%20OR%20fedora.model:soundrecording%20OR%20fedora.model:map%20OR%20fedora.model:graphic%20OR%20fedora.model:sheetmusic%20OR%20fedora.model:archive%20OR%20fedora.model:manuscript)&rows=0"
			search_public_url = api_url + "search?q=(fedora.model:monograph%20OR%20fedora.model:periodical%20OR%20fedora.model:soundrecording%20OR%20fedora.model:map%20OR%20fedora.model:graphic%20OR%20fedora.model:sheetmusic%20OR%20fedora.model:archive%20OR%20fedora.model:manuscript)%20AND%20dostupnost:public&rows=0"
			all_docs = get_json(search_all_url)
			begin
				documents_all
				library.documents_all = all_docs["response"]["numFound"]
			rescue
			end
			public_docs = get_json(search_public_url)
			begin
				library.documents_public = public_docs["response"]["numFound"]
			rescue
			end

			search_page_all_url = api_url + "search?q=fedora.model:page&rows=0"
			search_page_public_url = api_url + "search?q=fedora.model:page%20AND%20dostupnost:public&rows=0"
			page_all_docs = get_json(search_page_all_url)
			begin
				library.pages_all = page_all_docs["response"]["numFound"]
			rescue
			end
			page_public_docs = get_json(search_page_public_url)
			begin
				library.pages_public = page_public_docs["response"]["numFound"]
			rescue
			end

			date = Date.current
			if Record.where(library: library, date: date).blank?
				Record.create(library: library, date: date, documents_all: library.documents_all, documents_public: library.documents_public, pages_all: library.pages_all, pages_public: library.pages_public, version: library.version)
			end

			library.save
		end


		def get_response(url)
			puts url
			uri = URI.parse(url)
			http = Net::HTTP.new(uri.host, uri.port)
			http.read_timeout = 10
			if uri.scheme == "https"
				http.use_ssl = true
				http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			end
			request = Net::HTTP::Get.new(uri, initheader = {'Content-Type' =>'application/json', 'Accept-Language' => 'cs-CZ', 'Accept' =>'application/json'})
			begin
				http.request(request)
			rescue
				nil
			end
		end

		def get_text(url)
			response = get_response(url)
			if !response.nil?
				response.body
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
