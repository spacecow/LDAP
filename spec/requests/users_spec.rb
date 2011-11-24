require 'spec_helper'

describe "Users" do
  describe "index" do
    it "should be logged in" do
      visit root_path
      page.current_path.should eq root_path
    end
  end
end
