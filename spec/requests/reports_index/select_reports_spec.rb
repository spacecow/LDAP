require 'spec_helper'

describe "reports" do
  context "select" do
    before(:each) do
      day6 = Day.create(:date => "2012-06-20")
      day5 = Day.create(:date => "2012-05-20")
      dstat5 = FactoryGirl.create(:dailystat, day_id:day5.id)
      dstat6 = FactoryGirl.create(:dailystat, day_id:day6.id, gid_num:2, gid_string:nil)

      visit reports_path
      select "2012-05-01", :from => "Start month"
      select "2012-06-01", :from => "End month" 
      click_button "Go"
    end

    it "has a title" do
      page.should have_title('Reports: 2012-05 - 2012-06')
    end
    
    it "has the from-month selector filled in" do
      selected_value("Start month").should eq Report.first.id.to_s 
    end

    it "has the end-month selector filled in" do
      selected_value("End month").should eq Report.last.id.to_s 
    end

    it "has a monthstats table" do
      page.should have_a_table('monthstats')
      tablemap('monthstats').should eq [["factory","2","","/home/factory","2","2012-05-20"]] 
    end
  end
end

