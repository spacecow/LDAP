require 'spec_helper'

describe OperatorController do

  describe "GET 'schema'" do
    it "returns http success" do
      get 'schema'
      response.should be_success
    end
  end

end
