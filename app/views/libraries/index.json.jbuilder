json.array!(@libraries) do |library|
  json.extract! library, :id, :name, :code, :url, :version, :android, :ios
  json.logo asset_url(library.logo.url(:medium)) if library.logo?
  json.logo_thumb asset_url(library.logo.url(:thumb)) if library.logo?
  json.library_url library_url(library, format: :json)
end
