require 'spec_helper'

describe "report" do
  context "layout" do
    before(:each) do
      login
      visit report_path(date:'2011-11')
    end

    it "it has a title" do
      page.should have_title('2011-11')
    end
  end
end
