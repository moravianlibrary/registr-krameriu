class Library < ActiveRecord::Base


  default_scope  { order(:id => :asc) }
	#default_scope  { order(:version => :desc) }


	def client_url 
		"http://janrychtar.cz/kramerius/#/#{code}/"
	end

	def home_url 
		"#{url}search/"
	end

	#static methods
	def self.sum_of_all_documents
		Library.sum(:documents_all)
	end

	def self.sum_of_public_documents
		Library.sum(:documents_public)
	end


end
