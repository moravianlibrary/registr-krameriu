class SessionsController < ApplicationController
  def new
  end

  def create
  	user = User.find_by(login: params[:user][:login])
  	password = params[:user][:password]
  	if user && user.authenticate(password)
  		session[:user_id] = user.id
  		redirect_to root_path, notice: "Přhlášení proběhlo úspěšně"
  	else
  		redirect_to login_path, alert: "Přihlášení se nezdařilo"
  	end
  end

  def destroy
  	reset_session
  	redirect_to login_path, notice: "You have been logged out"
  end
end
