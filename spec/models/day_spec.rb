require 'spec_helper'

describe Day do
  it "" do
    Day.generate_userlist
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

