require 'open-uri'
require 'net/http'
require 'net/https'
require 'json'

class Processes

    def self.check_state
      puts "#{Time.now}"
      Library.all.each do |library|
        puts "#{Time.now}: #{library.name}"

        last_alive = library.alive
        library.alive = false
        base_url = library.search_url
        api_url = base_url + "api/v5.0/"
        api_url = library.url + "/catalogue/" if library.code == 'snk'
        k5info = Processes.get_json(api_url + "info")
        if !k5info || (k5info["version"] && k5info["version"].start_with?("7"))
          api_url = base_url + "api/client/v7.0/"
          k7info = Processes.get_json(api_url + "info")
          if k7info
            library.version = k7info["version"]
            library.alive = true
          elsif !k5info
            t = Processes.get_text(base_url)
              if t
                vv = t.match(/version: (.*), /)
                if vv
                  library.version = vv[1]
                  library.alive = true
                end
              end
          end
        elsif k5info
          library.version = k5info["version"]
          library.alive = true
        end

        library.save
        if last_alive != library.alive || State.where(library: library).count == 0
          value = library.alive ? 1 : 0
          puts "-- updating state of #{library.name} to #{value}"
          Library.update(last_state_switch: Time.now)
          State.create(library: library, at: Time.now, value: value)
        end
      end
      puts "#{Time.now}"
    end


    private

		def self.get_response(url)
			puts url
			uri = URI.parse(url)
			http = Net::HTTP.new(uri.host, uri.port)
			http.read_timeout = 5
			http.open_timeout = 5
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

		def self.get_text(url)
			response = Processes.get_response(url)
			if !response.nil?
				response.body
			end
		end

		def self.get_json(url)
			begin
				JSON.parse(Processes.get_text(url))
			rescue
			end
		end

end
