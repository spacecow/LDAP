require 'spec_helper'

describe "reports" do
  context "layout, without reports" do
    before(:each) do
      visit reports_path
    end

    it "it has a title" do
      page.should have_title('Reports')
    end

    it "has no reports div" do
      page.should_not have_div('months')
    end

    it "has a from-month selector" do
      selected_value("Start month").should be_blank
    end

    it "from-month contains all the reports" do
      options(:start_month).should eq "BLANK" 
    end

    it "has a end-month selector" do
      selected_value("End month").should be_blank
    end

    it "end-month contains all the reports" do
      options(:end_month).should eq "BLANK" 
    end

    it "has a submit button" do
      page.should have_button("Go")
    end
  end

  context "layout, with report" do
    before(:each) do
      Day.create(:date => "2011-11-25")
      visit reports_path
    end

    it "has a from-month selector" do
      selected_value("Start month").should be_blank
    end

    it "from-month contains all the reports" do
      options(:start_month).should eq "BLANK, 2011-11-01" 
    end

    it "has a end-month selector" do
      selected_value("End month").should be_blank
    end

    it "end-month contains all the reports" do
      options(:end_month).should eq "BLANK, 2011-11-01" 
    end

    it "has a reports div" do
      page.should have_div('months')
    end

    it "has a div for each month" do
      div('months').divs_no('month').should be(1)
    end

    it "has year-month link" do
      div('month',0).click_link('2011-11')
      current_path.should eq reports_path
      page.should have_title('Reports')
    end
  end

  context "layout, with reports" do
    before(:each) do
      Day.create(:date => "2012-06-20")
      Day.create(:date => "2011-11-25")
      visit reports_path
    end

    it "start-month contains all the reports in order" do
      options(:from_month).should eq "BLANK, 2011-11-01, 2012-06-01" 
    end

    it "end-month contains all the reports in order" do
      options(:end_month).should eq "BLANK, 2011-11-01, 2012-06-01" 
    end

  end
end
