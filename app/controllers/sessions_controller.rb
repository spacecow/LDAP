#require 'rpam'

class SessionsController < ApplicationController
#  include Rpam

  def new
  end
  
  def create
    if authpam(params[:login],params[:password])
      user = User.find_or_create_by_username(params[:login])
      session_userid(user.id)
      redirect_to schema_path, :notice => notify(:logged_in)
    else
      flash.now.alert = alertify(:invalid_login_or_password)
      render :new
    end
  end

  def destroy
    session_userid(nil)
    redirect_to root_path, :notice => notify(:logged_out)
  end

  private

    def authpam(login,password)
      true if login == "test" && password == "secret"
    end
end
