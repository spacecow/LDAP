require 'spec_helper'

describe "Layout" do
  context "site nav" do
    before(:each) do
      visit root_path
    end

    it "has a site nav div" do
      page.should have_div('site_nav')
    end

    it "has a link to the schema" do
      site_nav.click_link('Schema')
      current_path.should eq schema_path
    end

    it "has a link to the reports" do
      site_nav.click_link('Reports')
      current_path.should eq reports_path
    end
  end
end
