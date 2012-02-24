class Report < ActiveRecord::Base
  has_many :monthstats

  validates :date, presence:true, uniqueness:true
end
