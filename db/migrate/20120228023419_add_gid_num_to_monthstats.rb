class AddGidNumToMonthstats < ActiveRecord::Migration
  def self.up
    rename_column :monthstats, :gid, :gid_string
    add_column :monthstats, :gid_num, :integer
  end

  def self.down
    remove_column :monthstats, :gid_num
  end
end
