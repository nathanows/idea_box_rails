class SessionsController < ApplicationController
  def create
    user = User.find_by(username: params[:session][:username])
    if user && user.authenticate(params[:session][:password])
      session[:user_id] = user.id
      flash[:notice] = "You have successfully logged in."
      redirect_to user_path(user)
    else
      flash[:errors] = "Invalid Username or Password. Please try again."
      redirect_to root_url
    end
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_url, :notice => "Logout successful"
  end
end
