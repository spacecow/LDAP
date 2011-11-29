class Dailystat < ActiveRecord::Base
  belongs_to :days
  belongs_to :users

  attr_accessor :path

  before_create :calculate_account_size

  private

    def calculate_account_size
      self.account_size = %x[du -s #{@path}].split[0] || 0 
      if %w(development test).include?(Rails.env)
        self.account_size = "-" if !$?.success?
      end
      self.user_id = User.find_or_create_by_path(@path).id
    end
end
