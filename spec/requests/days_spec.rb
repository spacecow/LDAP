require 'spec_helper'

describe "Days" do
  context "links to" do
    it "schedule" do
      visit day_path Factory(:day)
      click_link "Schema"
    end
  end

  context "sort for" do
    before(:each) do
      day = Factory(:day)
      day.users << create_user("/home/testar",3)
      day.users << create_user("/home/tester",43)
      day.users << create_user("/home/test",123)
      visit day_path(day) 
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
