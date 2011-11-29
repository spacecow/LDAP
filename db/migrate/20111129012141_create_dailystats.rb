class CreateDailystats < ActiveRecord::Migration
  def self.up
    create_table :dailystats do |t|
      t.integer :day_id
      t.integer :user_id
      t.integer :account_size, :default => 0

      t.timestamps
    end
  end

  def self.down
    drop_table :dailystats
  end
end
