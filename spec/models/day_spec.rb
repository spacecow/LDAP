require 'spec_helper'

describe Day do
  context "#generate_userlist from scratch" do
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
      }.should change(Account, :count).by(2)
    end

    it "calculates the total user account size" do
      day = Day.generate_todays_userlist
      day.users_account_size_sum.should eq 16
    end

    it "generates a report if there is none" do
      lambda{ Day.generate_todays_userlist
      }.should change(Report,:count).by(1)
    end

    it "generates monthstats if there are none" do
      lambda{ Day.generate_todays_userlist
      }.should change(Monthstat, :count).by(2)
    end

    it "sets the status of the monthstat" do
      Day.generate_todays_userlist
      Monthstat.last.status.should_not be_nil
    end
  end #generate_userlist from scratch

  context "generate_userlist with existing report and mstat" do
    before(:each) do
      day = Factory(:day,date:'2011-11-25')
      test = Factory(:account, path:'/home/test')
      tester = Factory(:account, path:'/home/tester')
      day.dailystats << Dailystat.create(path:'/home/test')
      day.dailystats << Dailystat.create(path:'/home/tester')

      report = Factory(:report, date:"2011-11-01")

      mstat = Factory(:monthstat,report_id:report.id, day_of_registration:Date.parse('2011-11-25'), avg_account_size:5, tot_account_size:5, account_id:test.id)
      mstat.dailystats << Dailystat.first
      mstat = Factory(:monthstat,report_id:report.id, day_of_registration:Date.parse('2011-11-25'), avg_account_size:5, tot_account_size:5, account_id:tester.id)
      mstat.dailystats << Dailystat.last
    end

    it "does not generate a report if there already is one" do
      lambda{ Day.generate_userlist(Date.parse("2011-11-26"))
      }.should change(Report,:count).by(0)
    end

    it "does not generate mstats if they already exist" do
      lambda{ Day.generate_userlist(Date.parse("2011-11-26"))
      }.should change(Monthstat,:count).by(0)
    end

    it "updates the status of the monthstat" do
      Monthstat.last.update_attribute(:status,"wrong")
      Day.generate_userlist(Date.parse("2011-11-26"))
      Monthstat.last.status.should be_blank
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

