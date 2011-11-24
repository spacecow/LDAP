require 'spec_helper'

describe User do
  it "calculate the size of the account" do
    user = User.new(:path => "/home/test")
    user.calculate_account_size.should =~ /12/
  end
end
