class AddDayIdToUsers < ActiveRecord::Migration
  def self.up
    add_column :users, :day_id, :integer
  end

  def self.down
    remove_column :users, :day_id
  end
end
