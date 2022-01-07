class Api::LibrariesController < Api::ApiController
  
  def index
    result = []
    Library.all.each do |library|
      result << {
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
        model_monograph_all: library.model_monograph_all,
        model_monograph_public: library.model_monograph_public,
        model_periodical_all: library.model_periodical_all,
        model_periodical_public: library.model_periodical_public,
        model_map_all: library.model_map_all,
        model_map_public: library.model_map_public,
        model_graphic_all: library.model_graphic_all,
        model_graphic_public: library.model_graphic_public,
        model_soundrecording_all: library.model_soundrecording_all,
        model_soundrecording_public: library.model_soundrecording_public,
        model_archive_all: library.model_archive_all,
        model_archive_public: library.model_archive_public,
        model_sheetmusic_all: library.model_sheetmusic_all,
        model_sheetmusic_public: library.model_sheetmusic_public,
        model_manuscript_all: library.model_manuscript_all,
        model_manuscript_public: library.model_manuscript_public,
        model_article_all: library.model_article_all,
        model_article_public: library.model_article_public,

        created_at: library.created_at,
        updated_at: library.updated_at
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
      model_monograph_all: library.model_monograph_all,
      model_monograph_public: library.model_monograph_public,
      model_periodical_all: library.model_periodical_all,
      model_periodical_public: library.model_periodical_public,
      model_map_all: library.model_map_all,
      model_map_public: library.model_map_public,
      model_graphic_all: library.model_graphic_all,
      model_graphic_public: library.model_graphic_public,
      model_soundrecording_all: library.model_soundrecording_all,
      model_soundrecording_public: library.model_soundrecording_public,
      model_archive_all: library.model_archive_all,
      model_archive_public: library.model_archive_public,
      model_sheetmusic_all: library.model_sheetmusic_all,
      model_sheetmusic_public: library.model_sheetmusic_public,
      model_manuscript_all: library.model_manuscript_all,
      model_manuscript_public: library.model_manuscript_public,
      model_article_all: library.model_article_all,
      model_article_public: library.model_article_public,

      created_at: library.created_at,
      updated_at: library.updated_at
    }
    render json: result
  end

end
