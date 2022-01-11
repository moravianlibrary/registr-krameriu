class Api::LibrariesController < Api::ApiController
  
  def index
    result = []
    Library.all.each do |library|
      item = {
        id: library.id,
        code: library.code,
        sigla: library.sigla,
        name: library.name,
        name_en: library.name_en,
        alive: !!library.alive,
        version: library.version,
        url: library.url,
        new_client_url: library.new_client_url,
        logo: library.logo? ? logo_library_url(library) : nil,

        collections: library.collections,
        recommended_all: library.recommended,
        recommended_public: library.recommended_public,
        documents_all: library.documents_all,
        documents_public: library.documents_public,
        pages_all: library.pages_all,
        pages_public: library.pages_public,
        created_at: library.created_at,
        updated_at: library.updated_at
      }
      add_models(item, library)
      result << item
    end
    render json: result
  end


  def show
    library = Library.find_by(code: params[:id])
    result = {
      id: library.id,
      code: library.code,
      sigla: library.sigla,
      name: library.name,
      name_en: library.name_en,
      alive: !!library.alive,
      version: library.version,
      url: library.url,
      new_client_url: library.new_client_url,
      logo: library.logo? ? logo_library_url(library) : nil,
      email: library.email,
      web: library.web,
      street: library.street,
      city: library.city,
      zip: library.zip,
      latitude: library.latitude,
      longitude: library.longitude,
      collections: library.collections,
      recommended_all: library.recommended,
      recommended_public: library.recommended_public,
      documents_all: library.documents_all,
      documents_public: library.documents_public,
      pages_all: library.pages_all,
      pages_public: library.pages_public,
      created_at: library.created_at,
      updated_at: library.updated_at
    }
    add_models(result, library)
    render json: result
  end

  private 
    def add_models(item, library)
      available_models = [
				"monograph", "periodical", "soundrecording", "map", "graphic", "sheetmusic", "archive", "manuscript", "article", "periodicalitem", "supplement", "periodicalvolume", "monographunit", "track", "soundunit", "internalpart", "oldprintomnibusvolume", "picture", "page"
			]
      available_models.each do |model|
        prefix = "model_#{model}"
        all = "#{prefix}_all"
        pub = "#{prefix}_public"
        item[all] = library[all] || 0
        item[pub] = library[pub] || 0
      end
    end

end
