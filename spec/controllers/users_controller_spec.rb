require 'spec_helper'

describe UsersController do
  context "index" do
    it "get login data" do
      login = controller.send("login_data")
      login["userid"].should eq "testuser"
      login["passwd"].should eq "testing"
    end

    it "renders an error if login fails" do
      controller.stub!(:authpam).and_return(false)
      get :index 
      response.body.should =~ /error/
    end
  end
end
