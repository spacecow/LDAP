require 'spec_helper'

def controller_actions(controller)
  Rails.application.routes.routes.inject({}) do |hash, route|
    hash[route.requirements[:action]] = route.verb.downcase if route.requirements[:controller] == controller && !route.verb.nil?
    hash
  end
end

describe OperatorController do
  controller_actions = controller_actions("operator")

  describe "a user is not logged in" do
    controller_actions.each do |action,req|
      it "should not reach the #{action} page" do
        send("#{req}", "#{action}")
        response.redirect_url.should eq(login_url)
      end
    end
  end

  describe "a user is logged in" do
    before(:each) do
      user = Factory(:user)
      session[:userid] = user.id 
    end

    controller_actions.each do |action,req|
      it "should reach the #{action} page" do
        send("#{req}", "#{action}")
        response.redirect_url.should_not eq(login_url)
      end
    end
  end
end
