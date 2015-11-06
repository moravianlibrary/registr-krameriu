class Library < ActiveRecord::Base

	def client_url 
		"http://janrychtar.cz/kramerius/#/#{code}/"
	end

end
