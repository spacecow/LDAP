class ChangeSizeToAccountSizeForUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :account_size, :integer
    remove_column :users, :size
  end

  def self.down
    remove_column :users, :account_size
    add_column :users, :size, :string
  end
end
