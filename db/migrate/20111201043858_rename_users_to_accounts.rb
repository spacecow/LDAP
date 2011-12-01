class RenameUsersToAccounts < ActiveRecord::Migration
  def self.up 
    rename_table :users, :accounts
    rename_column :dailystats, :user_id, :account_id
  end

  def self.down
    rename_table :accounts, :users
    rename_column :dailystats, :account_id, :user_id
  end
end
