require 'spec_helper'

describe "Users" do
  describe "index" do
    it "should display the number of users" do
      visit users_path
      page.should have_content("2 user")
    end
    it "should display a list of users" do
      visit users_path
      table(0).should eq ["/home/test", "12"]
    end
  end

  context "sort for" do
    before(:each) do
      User.create(:path => "/home/testar", :account_size => 3)
      User.create(:path => "/home/tester", :account_size => 43)
      User.create(:path => "/home/test", :account_size => 123)
      visit users_path
    end

    it "Path" do
      click_link "Path"
      table(0,0).should have_content("/home/tester")
      table(1,0).should have_content("/home/testar")
      table(2,0).should have_content("/home/test")
    end
    it "Path x 2" do
      click_link "Path"
      click_link "Path"
      table(0,0).should have_content("/home/test")
      table(1,0).should have_content("/home/testar")
      table(2,0).should have_content("/home/tester")
    end

    it "Account Size" do
      click_link "Account Size"
      table(0,1).should have_content("3")
      table(1,1).should have_content("43")
      table(2,1).should have_content("123")
    end
    it "Account Size x 2" do
      click_link "Account Size"
      click_link "Account Size"
      table(0,1).should have_content("123")
      table(1,1).should have_content("43")
      table(2,1).should have_content("3")
    end
  end
end
