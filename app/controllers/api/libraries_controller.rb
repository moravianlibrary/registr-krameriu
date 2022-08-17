class Api::LibrariesController < Api::ApiController
  
  def index
    result = []
    Library.all.each do |library|
      if params[:detail] == "status"
        item = {
          code: library.code,
          alive: !!library.alive,
          last_state_switch: library.last_state_switch,
          state_duration: (Time.now - (library.last_state_switch || Time.now)).to_i
        }
      else 
        item = {
          id: library.id,
          code: library.code,
          sigla: library.sigla,
          name: library.name,
          name_en: library.name_en,
          alive: !!library.alive,
          last_state_switch: library.last_state_switch,
          state_duration: (Time.now - (library.last_state_switch || Time.now)).to_i,
          version: library.version,
          url: library.url,
          new_client_url: library.new_client_url,
          new_client_version: library.new_client_version,
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
          updated_at: library.updated_at,
          last_document_at: library.last_document_at,
          last_document_before: library.last_document_at.nil? ? nil : ((Time.now.to_date - library.last_document_at.to_date).to_i),
          licenses: library.licenses.nil? ? [] : JSON.parse(library.licenses)
        }
        add_models(item, library)
      end
      result << item
    end
    render json: result
  end


  def history
    result = []
    library = Library.find_by(code: params[:id])
    library.records.order(date: :desc).each do |record|
      result << {
        date: record.date,
        documents_all: record.documents_all,
        inc_documents_all: record.inc_documents_all,
        documents_public: record.documents_public,
        inc_documents_public: record.inc_documents_public,
        pages_all: record.pages_all,
        inc_pages_all: record.inc_pages_all,
        pages_public: record.pages_public,
        inc_pages_public: record.inc_pages_public,
        version: record.version
      }
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
      last_state_switch: library.last_state_switch,
      state_duration: (Time.now - (library.last_state_switch || Time.now)).to_i,
      version: library.version,
      url: library.url,
      new_client_url: library.new_client_url,
      new_client_version: library.new_client_version,
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
      updated_at: library.updated_at,
      last_document_at: library.last_document_at,
      last_document_before: library.last_document_at.nil? ? nil : ((Time.now.to_date - library.last_document_at.to_date).to_i),
      licenses: library.licenses.nil? ? [] : JSON.parse(library.licenses)
    }
    add_models(result, library)
    render json: result
  end

  private 
    def add_models(item, library)
      available_models = [
				"monograph", "periodical", "soundrecording", "map", "graphic", "sheetmusic", "archive", "manuscript", "article", "periodicalitem", "supplement", "periodicalvolume", "monographunit", "track", "soundunit", "internalpart", "convolute", "picture"
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
