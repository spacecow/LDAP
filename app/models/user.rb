class User < ActiveRecord::Base
  def calculate_account_size
    self.size = %x[du #{path} -s].split[0]
    self.save
    p User.last
  end
end

# == Schema Information
#
# Table name: users
#
#  id         :integer(4)      not null, primary key
#  path       :string(255)
#  created_at :datetime
#  updated_at :datetime
#

