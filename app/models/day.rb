# -*- coding: utf-8 -*-
class Day < ActiveRecord::Base
  has_many :dailystats, :dependent => :destroy, :after_add => :inc_users_count, :after_remove => :dec_users_count
  has_many :accounts, :through => :dailystats

  def dateformat; date.strftime("%Y年%m月%d日") end
  def delay_add_user(user); self.users << user end
  def lame_copy(date)
    day = Day.create(date:date,users_count:self.users_count,users_account_size_sum:self.users_account_size_sum)
    self.dailystats.each do |stat|
      stat.lame_copy(day.id)
    end
  end

  class << self

    def generate_userlist(s)
      day = Day.create(:date => s)
      path = "data/userlist_test.txt"
      if Rails.env.production?
        path = "data/userlist.txt"
        %x[ldapsearch -b "ou=Riec,o=TohokuUNV,c=JP" -x "(objectclass=*)" > data/userlist.txt]
        #%x[ldapsearch -b "ou=Riec,o=TohokuUNV,c=JP" -h 172.16.100.79 "(objectclass=*)" gecos homeDirectory > data/userlist.txt]
        #%x[ldapsearch -b "ou=Riec,o=TohokuUNV,c=JP" -h altair "(objectclass=*)" gecos homeDirectory > data/userlist.txt]
      end
      people, gid = false, ""
      report_date = s.strftime("%Y-%m-01")
      hash = Ldapsearch.group_hash('userlist.txt')
      File.open(path).each do |line|
        people = true if Ldapsearch.people_match(line) 
        people = false if line == "\n"
        if people
          if data = line.match(/gidNumber: (\d+)/)
            gid = "#{hash[data[1]]}|#{data[1]}"
          end
          if data = line.match(/homeDirectory: (.*)/)
            if %w(development test).include?(Rails.env)
              stat = Dailystat.create(path:data[1].chop,gid_string:gid.split('|')[0],gid_num:gid.split('|')[1])
            elsif Rails.env.production?
              stat = Dailystat.create(path:data[1],gid_string:gid.split('|')[0],gid_num:gid.split('|')[1])
            end
            day.dailystats << stat
            report = Report.find_or_create_by_date(report_date)
            stat.create_or_update_monthstats(report)
          end
        end
      end

      #File.open(path).each do |line|
      #  if data = line.match(/homeDirectory: (.*)/)
      #    report_date = s.strftime("%Y-%m-01")
      #    if %w(development test).include?(Rails.env)
      #      #day.accounts << Account.find_or_create_by_path(data[1])
      #      stat = Dailystat.create(:path => data[1].chop)
      #      day.dailystats << stat
      #      report = Report.find_or_create_by_date(report_date)
      #      stat.create_or_update_monthstats(report)
      #      #day.delay.delay_add_user(User.create(:path => data[1].chop))
      #    elsif Rails.env.production?
      #      #day.accounts << Account.find_or_create_by_path(data[1])
      #      stat = Dailystat.create(:path => data[1])
      #      day.dailystats << stat
      #      report = Report.find_or_create_by_date(report_date)
      #      stat.create_or_update_monthstats(report)
      #      #day.delay.delay_add_user(User.create(:path => data[1]))
      #    end
      #  end
      #end

      day
    end

    def generate_todays_userlist;
      generate_userlist(Date.today)
    end

    def lame_copy(date_to_copy,date)
      Day.where(date:Date.parse(date_to_copy)).first.lame_copy(date)
    end
    def fixed_lame_copy
      date_to_copy = "2012-04-12"
      date = "2012-04-11"
      Day.where(date:Date.parse(date_to_copy)).first.lame_copy(date)
    end
  end


  private

    def dec_account_size(dailystat)
      update_attribute(:users_account_size_sum, users_account_size_sum - dailystat.account_size)
    end
    def dec_users_count(dailystat)
      update_attribute(:users_count, users_count-1)
    end
    def inc_account_size(dailystat)
      update_attribute(:users_account_size_sum, users_account_size_sum + dailystat.account_size) 
    end
    def inc_users_count(dailystat)
      update_attribute(:users_count, users_count+1)
    end
end


# == Schema Information
#
# Table name: days
#
#  id                     :integer(4)      not null, primary key
#  date                   :date
#  created_at             :datetime
#  updated_at             :datetime
#  users_count            :integer(4)      default(0)
#  users_account_size_sum :integer(4)      default(0)
#

