#require 'spec_helper'
#load 'db/migrate/20111129012141_create_dailystats.rb'
#
#def null_output(&code)
#  stdout = $stdout
#  $stdout = File.new('/dev/null', 'w')
#  code.call
#  $stdout = stdout
#end
#
#describe CreateDailystats do
#  before(:each) do
#    @version = '20111129012141'
#    @prev_version = '20111128041535'
#  end
#
#  describe "describe up" do
#    before(:each) do
#      day = Factory(:day)
#      Factory(:user, :day_id => day.id)
#      null_output{ CreateDailystats.up } 
#    end
#
#    it "adds the model DailyStat" do
#      Dailystat.columns.map(&:name).should include("day_id")
#      Dailystat.columns.map(&:name).should include("user_id")
#      Dailystat.columns.map(&:name).should include("account_size")
#    end
#
#    it "eliminates day_id from the user model" do
#      Dailystat.reset_column_information
#      User.reset_column_information
#      User.columns.map(&:name).should_not include("day_id")
#    end
#
#    it "transfers day_id info to the dailystat model" do
#      Dailystat.reset_column_information
#      User.reset_column_information
#      User.columns.map(&:name).should_not include("day_id")
#    end
#
#    after(:each) do
#      null_output{ CreateDailystats.down } 
#    end
#  end
#
#  describe "describe down" do
#    before(:each) do
#      Dailystat.reset_column_information
#      User.reset_column_information
#      null_output{ CreateDailystats.up } 
#      null_output{ CreateDailystats.down } 
#      #Dailystat.columns.map(&:name) 
#    end
#
#    it "model dailystat should not exist" do
#      lambda{ Dailystat.columns
#      }.should raise_error Mysql2::Error
#    end
#
#    it "adds day_id to the user model" do
#      User.columns.map(&:name).should include("day_id")
#    end
#
#    after(:each) do
#    end
#  end
#end
