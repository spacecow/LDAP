class AddUserCountToDays < ActiveRecord::Migration
  def self.up
    add_column :days, :users_count, :integer, :default => 0
  end

  def self.down
    remove_column :days, :users_count
  end
end
