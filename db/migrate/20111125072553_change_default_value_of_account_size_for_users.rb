class ChangeDefaultValueOfAccountSizeForUsers < ActiveRecord::Migration
  def self.up
    remove_column :users, :account_size
    add_column :users, :account_size, :integer, :default => 0
  end

  def self.down
    remove_column :users, :account_size
    add_column :users, :account_size, :integer
  end
end
