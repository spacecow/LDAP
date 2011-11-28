require 'spec_helper'

describe "Users" do
  context "sort for" do
    before(:each) do
      User.create(:path => "/home/testar", :account_size => 3)
      User.create(:path => "/home/tester", :account_size => 43)
      User.create(:path => "/home/test", :account_size => 123)
      visit users_path
    end

  end
end
