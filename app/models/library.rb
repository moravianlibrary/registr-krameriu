class Library < ActiveRecord::Base
  before_save :refine_url
	before_save :normalize_blank_values

  #default_scope  { order(:id => :asc) }
	#default_scope  { order(:version => :desc) }

	def search_url 
		"#{url}/search/"
	end

	def client_url 
		"#{url}/client/"
	end


	def k4_client_url 
		if k4_client?
			search_url
		end
	end

	def k5_client_url 
		if k5_client?
			client_url
		end
	end


	def alt_client_universal_url 
		if alt_client_universal?
			"http://janrychtar.cz/kramerius/#/#{code}/"	
		end
	end


	def integer_version
		if version.blank?
			0
		else
			version.gsub(/\D/, "").to_i
		end
	end


	#static methods
	def self.sum_of_all_documents
		Library.sum(:documents_all)
	end

	def self.sum_of_public_documents
		Library.sum(:documents_public)
	end

	private
		def refine_url 
			end_index = 0
			if url.ends_with?("/search/")
				end_index = -9
			elsif url.ends_with?("/search")
				end_index = -8
			elsif url.ends_with?("/")
				end_index = -2
			end
			if end_index != 0
				self.url = "#{url[0..end_index]}"	
			else
				self.url = "#{url}"	
			end
		end

		def normalize_blank_values
	  	attributes.each do |column, value|
	    	self[column].present? || self[column] = nil
	  	end
		end

end
