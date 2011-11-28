class User < ActiveRecord::Base
  belongs_to :day

  before_create :calculate_account_size

  def calculate_account_size
    return if account_size != 0
    self.account_size = %x[du -s #{path}].split[0]
    if %w(development test).include?(Rails.env)
      self.account_size = "-" if !$?.success?
    end
  end
end




# == Schema Information
#
# Table name: users
#
#  id           :integer(4)      not null, primary key
#  path         :string(255)
#  created_at   :datetime
#  updated_at   :datetime
#  day_id       :integer(4)
#  account_size :integer(4)      default(0)
#

