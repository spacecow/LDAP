# -*- coding: utf-8 -*-
class Day < ActiveRecord::Base
  has_many :users

  def dateformat; date.strftime("%Y年%m月%d日") end

  def users_account_size_sum
    "#{users.map(&:account_size).inject(:+)}B"
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

