class Library < ActiveRecord::Base
  before_save :refine_url
  before_save :normalize_blank_values
  has_many :records, dependent: :destroy
  validates :code, presence: true, allow_blank: false
  validates :name, presence: true, allow_blank: false
  validates :url, presence: true, allow_blank: false

  has_attached_file :logo, styles: { medium: "300x300>", thumb: "100x100>" }, default_url: "/images/:style/missing.png"
  validates_attachment_content_type :logo, content_type: /\Aimage\/.*\z/

  def to_param
    code
  end


	def search_url
		"#{url}/search/"
	end

	def client_url
		"#{url}/client/"
	end


  def full_address
    if city.nil? && zip.nil?
      "#{street}"
    else
      "#{street}, #{city} #{zip}"
    end
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
			"http://www.digitalniknihovna.cz/#{code}/"
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
