class Account < ActiveRecord::Base
  before_create :set_gid

  has_many :dailystats, :dependent => :destroy
  has_many :days, :through => :dailystats

  has_many :monthstats

  validates_uniqueness_of :path

  class << self
    def set_gids
      Account.all.map(&:set_gid)
    end
  end

  private 

    def set_gid
      data = %x[id #{path.split('/').last}].match(/gid=(\d+)/)
      self.gid = data[1] if data
      #update_attribute(:gid,data[1]) if data
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

