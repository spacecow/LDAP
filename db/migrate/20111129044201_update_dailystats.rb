class UpdateDailystats < ActiveRecord::Migration
  def self.up
    User.reset_column_information
    User.all.each do |user|
      Dailystat.create(:day_id => user.day_id, :user_id => user.id, :account_size => user.account_size)
    end
    remove_column :users, :day_id
    remove_column :users, :account_size
  end

  def self.down
    add_column :users, :day_id, :integer
    add_column :users, :account_size, :integer, :default => 0
    Dailystat.reset_column_information
    Dailystat.all.each do |dailystat|
      User.find(dailystat.user_id).update_attributes(:day_id => dailystat.day_id, :account_size => dailystat.account_size)
    end 
  end
end
