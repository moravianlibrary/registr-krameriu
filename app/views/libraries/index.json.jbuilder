json.array!(@libraries) do |library|
  json.extract! library, :id, :name, :code, :url, :version, :android, :ios
  json.library_url library_url(library, format: :json)
end
