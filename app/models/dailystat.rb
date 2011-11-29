class Dailystat < ActiveRecord::Base
  belongs_to :day
  belongs_to :user

  attr_accessor :path

  before_create :calculate_account_size

  private

    def calculate_account_size
      if account_size == 0 #for rspec
        self.account_size = %x[du -s #{@path}].split[0] || 0 
        if %w(development test).include?(Rails.env)
          self.account_size = "-" if !$?.success?
        end
      end
      self.user_id = User.find_or_create_by_path(@path).id
    end
end

# == Schema Information
#
# Table name: dailystats
#
#  id           :integer(4)      not null, primary key
#  day_id       :integer(4)
#  user_id      :integer(4)
#  account_size :integer(4)      default(0)
#  created_at   :datetime
#  updated_at   :datetime
#

