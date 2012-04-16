require 'spec_helper'

describe "Days" do
  context "links to" do
    it "schedule" do
      visit day_path FactoryGirl.create(:day)
      click_link "Schema"
    end
  end

  context "sort for" do
    before(:each) do
      day = FactoryGirl.create(:day)
      day.dailystats << create_stat("/home/testar",3)
      day.dailystats << create_stat("/home/tester",43)
      day.dailystats << create_stat("/home/test",123)
      visit day_path(day) 
    end

#    it "Path" do
#      click_link "Path"
#      table(0,0).should have_content("/home/tester")
#      table(1,0).should have_content("/home/testar")
#      table(2,0).should have_content("/home/test")
#    end
#    it "Path x 2" do
#      click_link "Path"
#      click_link "Path"
#      table(0,0).should have_content("/home/test")
#      table(1,0).should have_content("/home/testar")
#      table(2,0).should have_content("/home/tester")
#    end

    it "Account Size ascending (default)" do
      tablecell(0,1).should have_content("3")
      tablecell(1,1).should have_content("43")
      tablecell(2,1).should have_content("123")
    end
    it "Account Size x 1 descending" do
      click_link "Account Size"
      tablecell(0,1).should have_content("123")
      tablecell(1,1).should have_content("43")
      tablecell(2,1).should have_content("3")
    end
  end
end
