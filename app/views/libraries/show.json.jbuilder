json.extract! @library, :id, :name, :code, :url, :version, :email, :intro, :right_msg, :pdf_max, :recommended, :recommended_public, :documents_all, :documents_public, :pages_all, :pages_public, :android, :ios, :k4_client_url, :k5_client_url, :alt_client_url, :alt_client_universal_url, :created_at, :updated_at
json.logo logo_library_url(@library) if @library.logo?
