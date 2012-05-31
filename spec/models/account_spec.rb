require 'spec_helper'

describe Account do
  context "copy gid to dailystat" do
    it "with dailystats" do
      account = FactoryGirl.create(:account,path:"/home/test")
      stat = FactoryGirl.create(:dailystat,account_id:account.id,path:"/home/test",gid_num:1002,gid_string:'test')
      account.copy_gid_to_dailystats
      Dailystat.last.gid_num.should eq 1002
      Dailystat.last.gid_string.should eq "test"
    end

    it "with dailystats and account gid is nil" do
      account = FactoryGirl.create(:account,path:"/home/test")
      account.gid = nil
      stat = FactoryGirl.create(:dailystat,account_id:account.id,path:"/home/test",gid_num:1002,gid_string:'test')
      account.copy_gid_to_dailystats
      Dailystat.last.gid_num.should be(1002)  
      Dailystat.last.gid_string.should eq 'test' 
    end

    it "without dailystats" do
      account = FactoryGirl.create(:account,path:"/home/test")
      account.copy_gid_to_dailystats
      Dailystat.count.should be(0)
    end
  end

  it "calculate the size of the account" do
    #user = User.create(:path => "/home/test")
    #user.calculate_account_size
    stat = create_stat("/home/test")
    stat.account_size.should eq 0 
  end

  it "cannot calculate the size of an account that does not exist" do
    stat = create_stat("/home/ghost")
    stat.account_size.should eq 0
  end

  context "on creation" do
    it "gid is not set for existing account" do
      FactoryGirl.create(:account,path:"/home/test")
      Account.last.gid.should be_nil 
      #Account.last.gid.should eq '1002(test)' 
    end
    it "not set for non-existing accounts" do
      FactoryGirl.create(:account,path:"/home/foweifj")
      Account.last.gid.should be_nil
    end
  end

  context "#update_gids" do
    it "on existing accounts without gid" do
      account = FactoryGirl.create(:account,path:"/home/test")
      account.update_attribute(:gid,"wrong")
      Account.last.gid.should eq 'wrong' 
      Account.update_gids
      Account.last.gid.should eq '1002(test)' 
    end
  end
end





# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  path       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

