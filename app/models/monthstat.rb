class Monthstat < ActiveRecord::Base
  belongs_to :report

  before_create :set_path,:set_gid,:set_userid,:set_days,:set_day_of_registration, :set_status

  has_many :dailystats
  belongs_to :account

  validates_presence_of :report, :account

  attr_accessible :report_id, :account_id, :avg_account_size

  def increase_days; self.days+=1 end
  def recalculate_avg_account_size(account_size)
    self.avg_account_size = (self.avg_account_size*self.days + account_size)/(self.days+1)
  end

  class << self
    def update_gids
      Monthstat.all.map(&:update_gid)
    end

    def update_statuses
      Monthstat.all.map(&:update_status)
    end
  end

  def update_gid
    update_attribute(:gid,account.gid)
  end

  def update_status
    if (Time.now - updated_at) > 1.day 
      update_attribute(:status,get_status)
    end
  end

  private

    def account_exists?; %x[id #{userid}].match(/gid=(\d+)/) end
    def get_status
      if !account_exists?
        'dead'
      elsif !path_exists?
        'empty'
      else
        ""
      end
    end
    def path_exists?; File.directory?(path) end
    def set_day_of_registration
      self.day_of_registration = account.days.order(:date).first.date unless account.days.empty?
    end
    def set_days; self.days = 1 end
    def set_gid; self.gid = account.gid end
    def set_path; self.path = account.path end
    def set_status; self.status = get_status end
    def set_userid; self.userid = path.split('/')[-1] end

end
