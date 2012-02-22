class Account < ActiveRecord::Base
  has_many :dailystats, :dependent => :destroy
  has_many :days, :through => :dailystats

  def set_gid
    data = %x[id #{path.split('/').last}].match(/gid=(.*?)\s/)
    update_attribute(:gid,data[1]) if data
  end

  class << self
    def set_gids
      Account.all.map(&:set_gid)
    end
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

