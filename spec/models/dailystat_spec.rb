require 'spec_helper'

describe Dailystat do
  describe "#calculate_account_size" do
    before(:each) do
      @stat = Dailystat.create(path:"/home/test")
    end

    it "calculates the account size" do
      @stat.account_size.should be(12)
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

