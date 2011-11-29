require 'spec_helper'

describe Day do
  context "#generate_userlist" do
    it "generates a day with said date" do
      day = Day.generate_userlist(Date.today)
      day.date.should eq Date.today
    end

    it "generates dailystat models" do
      lambda{ Day.generate_todays_userlist
      }.should change(Dailystat, :count).by(2)
    end

    it "generates user models" do
      lambda{ Day.generate_todays_userlist
      }.should change(User, :count).by(2)
    end

    it "calculates the total user account size" do
      day = Day.generate_todays_userlist
      day.users_account_size_sum.should eq 16
    end
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

