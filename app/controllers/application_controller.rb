class ApplicationController < ActionController::Base
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.
  protect_from_forgery with: :exception

  helper_method :ensure_login, :logged_in?, :current_user, :asset_exist?

  protected

  	def ensure_login
  		redirect_to login_path unless logged_in?
  	end

  	def logged_in?
  		session[:user_id]
  	end

  	def current_user
  		@current_user ||= User.find(session[:user_id])
  	end

    def asset_exist?(path)
      if Rails.configuration.assets.compile
        Rails.application.precompiled_assets.include? path
      else
        Rails.application.assets_manifest.assets[path].present?
    end
end


end
