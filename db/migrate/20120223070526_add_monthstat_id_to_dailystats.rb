class AddMonthstatIdToDailystats < ActiveRecord::Migration
  def self.up
    add_column :dailystats, :monthstat_id, :integer
  end

  def self.down
    remove_column :dailystats, :monthstat_id
  end
end
