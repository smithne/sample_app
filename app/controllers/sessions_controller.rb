class SessionsController < ApplicationController

  def new

  end

  def create
    user = User.find_by(email: params[:session][:email].downcase)
    if user && user.authenticate(params[:session][:password])
      flash.now[:success] = "Login successful! User: " + user.name
    else
      flash.now[:danger] = "Failed to login!"
    end
    render 'new'
  end

  def destroy

  end

end
