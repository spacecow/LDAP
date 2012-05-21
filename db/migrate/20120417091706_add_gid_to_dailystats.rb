class AddGidToDailystats < ActiveRecord::Migration
  def self.up
    add_column :dailystats, :gid_num, :integer
    add_column :dailystats, :gid_string, :string
  end

  def self.down
    remove_column :dailystats, :gid_string
    remove_column :dailystats, :gid_num
  end
end
