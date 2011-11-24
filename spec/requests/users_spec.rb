require 'spec_helper'

describe "Users" do
  describe "index" do
    it "should display the number of users" do
      visit users_path
      page.should have_content("1 user")
    end
    it "should display a list of users" do
      visit users_path
      table.should eq [["/home/test", "12"]]
    end
  end
end
