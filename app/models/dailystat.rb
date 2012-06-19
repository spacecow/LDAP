class Dailystat < ActiveRecord::Base
  belongs_to :day
  belongs_to :account
  belongs_to :monthstat

  attr_accessor :path
  before_create :set_account
  #before_create :set_gid

  validates_presence_of :gid_num
  #some ppl refer to a gid_num that doesn't exist :gid_string

  def account_gid; account.gid end
  def account_path; account.path end

  def check_account; !account.nil? end

  def create_or_update_monthstats(report)
    if !self.account.monthstats.map(&:report).include?(report)
      monthstat = Monthstat.create!(report_id:report.id, account_id:self.account.id, day_of_registration:self.account.days.order(:date).first.date, gid_num:self.gid_num, gid_string:self.gid_string)
      monthstat.dailystats << self
    else
      self.account.monthstats.select{|e| e.report==report}.each do |monthstat|
        monthstat.increase_days
        #monthstat.set_status
        monthstat.save
        self.update_attribute(:monthstat_id,monthstat.id)
        monthstat.update_attributes(gid_num:self.gid_num, gid_string:self.gid_string)
        
      end
    end
  end

  def migrate_gid
    if account.check_advance_gid
      update_attribute(:gid_num, account.gid_num)
      update_attribute(:gid_string, account.gid_string)
    else
      update_attribute(:gid_num, account.gid)
      update_attribute(:gid_string, nil)
    end 
  end

  def lame_copy(day_id)
    Dailystat.create(day_id:day_id, path:account.path, account_size:self.account_size, gid_num:self.gid_num, gid_string:self.gid_string)
  end

  class << self

    def all_in_month(date)
      where("days.date >= :start_date and days.date <= :end_date", {start_date:date.beginning_of_month, end_date:date.end_of_month}).includes(:day) 
    end

    def check_accounts; all.map(&:check_account) end

  end

  private

    def set_account 
      #if account_size == 0 #for rspec
      #  self.account_size = %x[du -s #{@path}].split[0] || 0 
      #  if %w(development test).include?(Rails.env)
      #    self.account_size = "-" if !$?.success?
      #  end
      #end
      if account_id.nil?
        account = Account.find_or_create_by_path(@path)
        self.account_id = account.id
      end 
    end

    #def set_gid
    #  data = %x[id #{path.split('/').last}].match(/gid=(.+?)\((.+?)\)/)
    #  self.gid_num = data[1] if data
    #  self.gid_string = data[2] if data
    ##  #update_attribute(:gid,data[1]) if data
    #end

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

