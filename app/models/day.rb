# -*- coding: utf-8 -*-
class Day < ActiveRecord::Base
  has_many :dailystats, :dependent => :destroy, :after_add => [:inc_users_count, :inc_account_size], :after_remove => [:dec_users_count, :dec_account_size] 
  has_many :accounts, :through => :dailystats 

  def dateformat; date.strftime("%Y年%m月%d日") end

  class << self

    def generate_userlist(s)
      day = Day.create(:date => s)
      path = "data/userlist_test.txt"
      if Rails.env.production?
        path = "data/userlist.txt"
        %x[ldapsearch -b "ou=Riec,o=TohokuUNV,c=JP" -h 172.16.100.79 "(objectclass=*)" gecos homeDirectory > data/userlist.txt]
        #%x[ldapsearch -b "ou=Riec,o=TohokuUNV,c=JP" -h altair "(objectclass=*)" gecos homeDirectory > data/userlist.txt]
      end
      File.open(path).each do |line|
        if data = line.match(/homeDirectory: (.*)/)
          if %w(development test).include?(Rails.env)
            day.dailystats << Dailystat.create(:path => data[1].chop)
            #day.delay.delay_add_user(User.create(:path => data[1].chop))
          elsif Rails.env.production?
            day.dailystats << Dailystat.create(:path => data[1])
            #day.delay.delay_add_user(User.create(:path => data[1]))
          end
        end
      end
      day
    end

    def generate_todays_userlist;
      generate_userlist(Date.today)
     end
  end

  def delay_add_user(user); self.users << user end

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

