class CreateMonthstats < ActiveRecord::Migration
  def self.up
    create_table :monthstats do |t|
      t.integer :report_id
      t.integer :account_id

      t.string :userid
      t.string :gid
      t.string :path
      t.integer :days
      t.decimal :avg_account_size, :precision=>12, :scale=>2
      t.date :day_of_registration 
      t.timestamps
    end
  end

  def self.down
    drop_table :monthstats
  end
end
