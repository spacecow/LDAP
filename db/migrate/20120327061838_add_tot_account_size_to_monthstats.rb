class AddTotAccountSizeToMonthstats < ActiveRecord::Migration
  def self.up
    add.column :monthstats, :tot_account_size, :decimal, :precision=>13, :scale=>2
  end

  def self.down
    remove_column :monthstats, :tot_account_size
  end
end
