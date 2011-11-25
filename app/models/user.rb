require 'stringio'
 
class User < ActiveRecord::Base
  def calculate_account_size
    self.account_size = %x[du -s #{path}].split[0]
    if %w(development test).include?(Rails.env)
      self.account_size = "-" if !$?.success?
    end
    self.save
  end

  class << self
    def generate_userlist
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
#  account_size :integer(4)
#  day_id       :integer(4)
#

