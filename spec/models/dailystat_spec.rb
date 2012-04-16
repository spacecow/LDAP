require 'spec_helper'

describe Dailystat do
  describe "#lame_copy" do
    before(:each) do
      date = "2012-04-12"
      @day_to_copy = FactoryGirl.create(:day,date:Date.parse("2012-04-12"))
      @account = FactoryGirl.create(:account,path:"/home/tester")
      report = FactoryGirl.create(:report)
      mstat = FactoryGirl.create(:monthstat,report_id:report.id,account_id:@account.id)
      @stat = FactoryGirl.create(:dailystat,day_id:@day_to_copy.id,path:"/home/tester",monthstat_id:mstat.id)
      @stat.account_size = 13

      @day = FactoryGirl.create(:day,date:Date.parse("2012-04-11"))
      @stat.lame_copy(@day.id)
    end

    it "stat copy points at the new day" do
      Dailystat.last.day_id.should eq @day.id
    end
    it "stat copy has the same account" do
      Dailystat.last.account_id.should eq @account.id
    end
    it "stat copy has the same account size" do
      Dailystat.last.account_size.should eq @stat.account_size
    end
    it "stat copy has no mstat set" do
      Dailystat.last.monthstat_id.should be_nil
    end
  end

  describe "#calculate_account_size" do
    before(:each) do
      day = FactoryGirl.create(:day)
      account = FactoryGirl.create(:account, path:'/home/test')
      #day.accounts << account
      #@stat = Dailystat.last
      @stat = Dailystat.create(path:"/home/test")
    end

    it "calculates the account size" do
      @stat.account_size.should be(0)
    end

    it "creates an account" do
      @stat.account.should eq Account.last
    end

    it "the account get its path set" do
      Account.last.path.should eq '/home/test'
    end 

    it "the account get its gid set" do
      Account.last.gid.should eq '1002(test)'
    end 
  end
end

# == Schema Information
#
# Table name: dailystats
#
#  id           :integer(4)      not null, primary key
#  day_id       :integer(4)
#  user_id      :integer(4)
#  account_size :integer(4)      default(0)
#  created_at   :datetime
#  updated_at   :datetime
#

