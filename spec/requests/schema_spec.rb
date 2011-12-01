# -*- coding: utf-8 -*-
require 'spec_helper'

describe "schema", :focus => true do
  it "lists logged days" do
    Day.create(:date => "2011-11-25")
    login
    visit schema_path
    table(0,0).should have_content("2011年11月25日")
  end

  it "gives info about date, users, space" do
    day = Factory(:day, :date => "2011-11-25")
    day.dailystats << create_stat("/home/test",12)
    login
    visit schema_path
    table(0).should eq ["2011年11月25日", "1", "12"]
  end

  context "link to" do
    it "day" do
      day = Factory(:day, :date => "2011-11-25")
      login
      visit schema_path
      click_link("2011年11月25日")
      page.current_path.should == day_path(day)
    end
  end

  context "sort for" do
    before(:each) do
      day24 = Day.create(:date => "2011-11-25")
      day25 = Day.create(:date => "2011-11-24")
      day24.dailystats << create_stat("/home/testar",3)
      day24.dailystats << create_stat("/home/tester",43)
      day25.dailystats << create_stat("/home/test",123)
      login
      visit schema_path
    end

    it "Date ascending (default)" do
      table(0,0).should have_content("2011年11月24日")
      table(1,0).should have_content("2011年11月25日")
    end
    it "Date descending" do
      click_link "Date"
      table(0,0).should have_content("2011年11月25日")
      table(1,0).should have_content("2011年11月24日")
    end

    it "Accounts ascending" do
      click_link "Accounts"
      table(0,1).should have_content("1")
      table(1,1).should have_content("2")
    end
    it "Accounts descending" do
      click_link "Accounts"
      click_link "Accounts"
      table(0,1).should have_content("2")
      table(1,1).should have_content("1")
    end

    it "Account Size ascending" do
      click_link "Account Size Sum"
      table(0,2).should have_content("46")
      table(1,2).should have_content("123")
    end
    it "Account size descending" do
      click_link "Account Size Sum"
      click_link "Account Size Sum"
      table(0,2).should have_content("123")
      table(1,2).should have_content("46")
    end
  end
end
