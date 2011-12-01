class Account < ActiveRecord::Base
  has_many :dailystats, :dependent => :destroy
  has_many :days, :through => :dailystats
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

