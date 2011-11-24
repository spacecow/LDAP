require 'spec_helper'

describe User do
  it "calculate the size of the account" do
    user = User.create(:path => "/home/test")
    user.calculate_account_size
    User.last.size.should eq "12"
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

