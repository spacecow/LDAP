require 'spec_helper'

describe Account do
  it "calculate the size of the account" do
    #user = User.create(:path => "/home/test")
    #user.calculate_account_size
    stat = create_stat("/home/test")
    stat.account_size.should eq 12
  end

  it "cannot calculate the size of an account that does not exist" do
    stat = create_stat("/home/ghost")
    stat.account_size.should eq 0
  end

  context "on creation" do
    it "gid is set for existing account" do
      Factory(:account,path:"/home/test")
      Account.last.gid.should eq '1002(test)' 
    end
    it "not set for non-existing accounts" do
      Factory(:account,path:"/home/foweifj")
      Account.last.gid.should be_nil
    end
  end

  context "#update_gids" do
    it "on existing accounts without gid" do
      account = Factory(:account,path:"/home/test")
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

