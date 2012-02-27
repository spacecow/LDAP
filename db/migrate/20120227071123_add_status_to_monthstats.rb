class AddStatusToMonthstats < ActiveRecord::Migration
  def self.up
    add_column :monthstats, :status, :string
  end

  def self.down
    remove_column :monthstats, :status
  end
end
