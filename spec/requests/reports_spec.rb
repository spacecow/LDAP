require 'spec_helper'

describe "reports" do
  context "layout, without reports" do
    before(:each) do
      login
      visit reports_path
    end

    it "it has a title" do
      page.should have_title('Reports')
    end

    it "has no reports div" do
      page.should_not have_div('months')
    end
  end

  context "layout, with reports" do
    before(:each) do
      Day.create(:date => "2011-11-25")
      login
      visit reports_path
    end

    it "has a reports div" do
      page.should have_div('months')
    end

    it "has a div for each month" do
      div('months').divs_no('month').should be(1)
    end

    it "has year-month link" do
      div('month',0).click_link('2011-11')
      current_path.should eq report_path
      page.should have_title('2011-11')
    end
  end
end
