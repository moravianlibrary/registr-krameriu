class Library < ActiveRecord::Base


  default_scope  { order(:id => :asc) }

	def client_url 
		"http://janrychtar.cz/kramerius/#/#{code}/"
	end

end
