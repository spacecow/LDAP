class Dailystat < ActiveRecord::Base
  belongs_to :day
  belongs_to :account

  attr_accessor :path
  before_create :calculate_account_size

  def account_gid; account.gid end
  def account_path; account.path end

  private

    def calculate_account_size
      if account_size == 0 #for rspec
        self.account_size = %x[du -s #{@path}].split[0] || 0 
        if %w(development test).include?(Rails.env)
          self.account_size = "-" if !$?.success?
        end
      end
      if account_id.nil?
        account = Account.find_or_create_by_path(@path)
        account.set_gid
        self.account_id = account.id
      end 
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

