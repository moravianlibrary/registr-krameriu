json.array!(@libraries) do |library|
  json.extract! library, :id, :name, :code, :url, :version
  json.url library_url(library, format: :json)
end
