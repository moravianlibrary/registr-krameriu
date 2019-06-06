json.array!(@libraries) do |library|
  json.extract! library, :id, :alive, :sigla, :name, :oai_provider, :new_client_url, :name_en, :code, :url, :version, :android, :ios
  json.logo logo_library_url(library) if library.logo?
  json.library_url library_url(library, format: :json)
end
