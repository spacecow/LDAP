class Monthstat < ActiveRecord::Base
  belongs_to :report

  before_create :set_path,:set_gid,:set_userid,:set_days,:set_day_of_registration

  has_many :dailystats
  belongs_to :account

  validates_presence_of :report, :account

  attr_accessible :report_id, :account_id, :avg_account_size

  def increase_days; self.days+=1 end
  def recalculate_avg_account_size(account_size)
    self.avg_account_size = (self.avg_account_size*self.days + account_size)/(self.days+1)
  end

  private

    def set_day_of_registration
      self.day_of_registration = account.days.order(:date).first.date
    end
    def set_days; self.days = 1 end
    def set_gid; self.gid = account.gid end
    def set_path; self.path = account.path end
    def set_userid; self.userid = path.split('/')[-1] end

end
