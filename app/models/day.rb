# -*- coding: utf-8 -*-
class Day < ActiveRecord::Base
  has_many :users

  def dateformat; date.strftime("%Y年%m月%d日") end

  def users_account_size_sum
    "#{users.map(&:account_size).inject(:+)}B"
  end

  class << self
    def generate_userlist(s)
      day = Day.create(:date => s)
      path = "data/userlist_test.txt"
      path = "data/userlist.txt" if Rails.env.production?
      File.open(path).each do |line|
        if data = line.match(/homeDirectory: (.*)/)
          if %w(development test).include?(Rails.env)
            day.users << User.create(:path => data[1].chop)
          elsif Rails.env.production?
            day.users << User.create(:path => data[1])
          end
        end
      end
      day
    end

    def generate_todays_userlist; generate_userlist(Date.today.strftime("%Y-%m-%d")) end
  end
end

# == Schema Information
#
# Table name: days
#
#  id         :integer(4)      not null, primary key
#  date       :date
#  created_at :datetime
#  updated_at :datetime
#

