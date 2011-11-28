# -*- coding: utf-8 -*-
require 'spec_helper'

describe "schema" do
  it "lists logged days" do
    Day.create(:date => "2011-11-25")
    visit schema_path
    table(0,0).should have_content("2011年11月25日")
  end

  it "gives info about date, users, space" do
    day = Factory(:day, :date => "2011-11-25")
    day.users << Factory(:user, :path => "/home/test", :account_size => 12)
    visit schema_path
    table(0).should eq ["2011年11月25日", "1", "12"]
  end

  context "sort for" do
    before(:each) do
      day24 = Day.create(:date => "2011-11-25")
      day25 = Day.create(:date => "2011-11-24")
      day24.users << User.create(:path => "/home/testar", :account_size => 3)
      day24.users << User.create(:path => "/home/tester", :account_size => 43)
      day25.users << User.create(:path => "/home/test", :account_size => 123)
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

    it "Users ascending" do
      click_link "Users"
      table(0,1).should have_content("1")
      table(1,1).should have_content("2")
    end
    it "Users descending" do
      click_link "Users"
      click_link "Users"
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
