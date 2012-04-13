class Dailystat < ActiveRecord::Base
  belongs_to :day
  belongs_to :account
  belongs_to :monthstat

  attr_accessor :path
  before_create :calculate_account_size

  def account_gid; account.gid end
  def account_path; account.path end

  def create_or_update_monthstats(report)
    if !self.account.monthstats.map(&:report).include?(report)
      monthstat = Monthstat.create!(report_id:report.id, account_id:self.account.id, day_of_registration:self.account.days.order(:date).first.date, avg_account_size:self.account_size,tot_account_size:self.account_size)
      monthstat.dailystats << self
    else
      self.account.monthstats.select{|e| e.report==report}.each do |monthstat|
        monthstat.recalculate_avg_account_size(self.account_size)
        monthstat.increase_tot_account_size(self.account_size)
        monthstat.increase_days
        monthstat.set_status
        monthstat.save
        self.update_attribute(:monthstat_id,monthstat.id) 
      end
    end
  end

  def lame_copy(day_id)
    Dailystat.create(day_id:day_id,path:account.path,account_size:self.account_size)
  end

  class << self

    def all_in_month(date)
      where("days.date >= :start_date and days.date <= :end_date", {start_date:date.beginning_of_month, end_date:date.end_of_month}).includes(:day) 
    end

  end

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

