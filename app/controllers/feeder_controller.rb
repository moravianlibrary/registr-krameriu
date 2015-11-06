require 'open-uri'
require 'net/http'
require 'net/https'
require 'json'
class FeederController < ApplicationController



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
		render :text => "ok",:content_type => "text/plain"
		#redirect_to libraries_path, notice: 'Načtení dat dokončeno'
	end

	def ping
		render :text => "ok",:content_type => "text/plain"
	end

	private

		def update_library(library)
			base_url = library.url + "search/"
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
				vv = t.match(/version: (.*), /)
				if vv
					library.version = vv[1]
				end
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
				library.documents_all = all_docs["response"]["numFound"]
			rescue
			end
			public_docs = get_json(search_public_url)
			begin
				library.documents_public = public_docs["response"]["numFound"]
			rescue
			end			


			library.save
		end


		def get_text(url)
			puts url
			uri = URI.parse(url)
			http = Net::HTTP.new(uri.host, uri.port)
			if uri.scheme == "https"
				http.use_ssl = true
				http.verify_mode = OpenSSL::SSL::VERIFY_NONE
			end			
			request = Net::HTTP::Get.new(uri, initheader = {'Content-Type' =>'application/json', 'Accept' =>'application/json'})
			response = http.request(request)
			response.body
		end


		def get_json(url)
			begin
				JSON.parse(get_text(url))
			rescue 
			end
		end

end