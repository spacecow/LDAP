class AddGidToAccounts < ActiveRecord::Migration
  def self.up
    add_column :accounts, :gid, :string
  end

  def self.down
    remove_column :accounts, :gid
  end
end
