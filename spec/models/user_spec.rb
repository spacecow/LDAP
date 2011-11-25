require 'spec_helper'

describe User do
  it "calculate the size of the account" do
    user = User.create(:path => "/home/test")
    user.calculate_account_size
    User.last.account_size.should eq 12
  end

  it "cannot calculate the size of an account that does not exist" do
    user = User.create(:path => "/home/ghost", :account_size => "-")
    user.calculate_account_size
    User.last.account_size.should eq 0
  end
end



# == Schema Information
#
# Table name: users
#
#  id           :integer(4)      not null, primary key
#  path         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  account_size :integer(4)
#  day_id       :integer(4)
#

