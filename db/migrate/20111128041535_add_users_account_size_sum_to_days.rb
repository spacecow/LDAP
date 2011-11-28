class AddUsersAccountSizeSumToDays < ActiveRecord::Migration
  def self.up
    add_column :days, :users_account_size_sum, :integer, :default => 0
  end

  def self.down
    remove_column :days, :users_account_size_sum
  end
end
