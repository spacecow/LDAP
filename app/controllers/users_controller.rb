class UsersController < ApplicationController
  def index
    data = login_data
    if login(data["userid"],data["passwd"])
    else render :text => "error"
    end
  end

  private

    def login(userid,passwd)
      if %w(development test).include?(Rails.env)
        return true
      elsif Rails.env == "production"
        return authpam(login_data["userid"],login_data["passwd"])
      else
        return false 
      end
    end
    def login_data
      YAML::load(File.open("#{Rails.root.to_s}/config/login.yml"))
    end
end
