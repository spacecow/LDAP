# -*- coding: utf-8 -*-

require 'spec_helper'

describe "schema" do
  it "lists logged days" do
    Day.create(:date => "2011-11-25")
    visit schema_path
    table(0,0).should have_content("2011年11月25日")
  end

  it "lists logged days in order" do
    Day.create(:date => "2011-11-25")
    Day.create(:date => "2011-11-24")
    visit schema_path
    table(0,0).should have_content("2011年11月24日")
    table(1,0).should have_content("2011年11月25日")
  end

  it "gives info about date, users, space" do
    day = Factory(:day, :date => "2011-11-25")
    Factory(:user, :path => "/home/test", :account_size => 12, :day_id => day.id)
    visit schema_path
    table(0).should eq ["2011年11月25日", "1 user", "12B"]
  end
end
