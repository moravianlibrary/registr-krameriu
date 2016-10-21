json.extract! @library, :id, :name, :code, :url, :version, :email, :intro, :right_msg, :pdf_max, :recommended, :recommended_public, :documents_all, :documents_public, :pages_all, :pages_public, :android, :ios, :k4_client_url, :k5_client_url, :alt_client_url, :alt_client_universal_url, :created_at, :updated_at
json.logo asset_url(@library.logo.url(:medium)) if @library.logo?
json.logo_thumb asset_url(@library.logo.url(:thumb)) if @library.logo?
