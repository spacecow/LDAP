require 'spec_helper'

describe "report" do
  before(:each) do
    login 
    @report = Factory(:report,date:Date.parse('2011-11-01'))
  end

  context "layout, with non-existing monthstat" do

    before(:each) do
      day = Factory(:day,date:'2011-11-25')
      account = Factory(:account, path:'/home/tester')
      day.dailystats << Dailystat.create(path:'/home/tester')

      Dailystat.last.monthstat.should be_nil
      visit report_path(@report)
    end 

    it "the dailystat get its monthstat set" do
      Dailystat.last.monthstat.should_not be_nil
      Dailystat.last.monthstat.should eq Monthstat.last
    end

    it "the monthstat gets it account set" do
      Monthstat.last.account.should eq Account.last
    end 

    it "the monthstat gets its path set" do
      Monthstat.last.path.should eq '/home/tester'
    end
    it "the monthstat gets its userid set" do
      Monthstat.last.userid.should eq 'tester'
    end
    it "the monthstat gets its gid_num set" do
      Monthstat.last.gid_num.should eq 1004
    end
    it "the monthstat gets its gid_string set" do
      Monthstat.last.gid_string.should eq 'tester'
    end
    it "the monthstat gets its day set" do
      Monthstat.last.days.should be(1)
    end
    it "the monthstat gets its day of registration set" do
      Monthstat.last.day_of_registration.should eq Date.parse('2011-11-25') 
    end
    it "the monthstat gets its avg account size set" do
      Monthstat.last.avg_account_size.to_digits.should eq "4.0" 
    end

#    it "has a csv button" do
#      page.should have_button('CSV')
#    end
#
#    it "csv button links to a csv download" do
#      click_button 'CSV'
#    end
  end

  context "layout, with existing monthstat" do
    before(:each) do
      day = Factory(:day,date:'2011-11-25')
      account = Factory(:account, path:'/home/tester')
      day.dailystats << Dailystat.create(path:'/home/tester')

      Day.last.accounts.should_not be_empty
      Day.last.accounts.should eq [Account.last]
      Day.last.dailystats.should_not be_empty
      Day.last.dailystats.should eq [Dailystat.last]
      Account.last.days.should_not be_empty 
      Account.last.days.should eq [Day.last]
      Account.last.dailystats.should_not be_empty
      Account.last.dailystats.should eq [Dailystat.last]

      @monthstat = Factory(:monthstat,report_id:@report.id, day_of_registration:Date.parse('2011-11-25'), avg_account_size:5, account_id:account.id)
      @monthstat.dailystats << Dailystat.last

      day2 = Factory(:day,date:'2011-11-26')
      day2.dailystats << Dailystat.create(path:'/home/tester')
  
      visit report_path(@report)
    end 

    it "the dailystat gets reported" do
      Dailystat.last.monthstat.should eq Monthstat.last 
    end
  
    it "the monthstat belongs to the report" do
      Report.last.monthstats.should eq [Monthstat.last]
    end

    it "the monthstat has its path set" do
      Monthstat.last.path.should eq '/home/tester'
    end
    it "the monthstat has its userid set" do
      Monthstat.last.userid.should eq 'tester'
    end
    it "the monthstat has its gid set" do
      Monthstat.last.gid_num.should eq 1004
    end
    it "the monthstat has its gid set" do
      Monthstat.last.gid_string.should eq 'tester'
    end
    it "the monthstat gets its day increased" do
      Monthstat.last.days.should eq 2
    end
    it "the monthstat has its day of registration set" do
      Monthstat.last.day_of_registration.should eq Date.parse('2011-11-25') 
    end
    it "the monthstat gets its avg account size set" do
      Monthstat.last.avg_account_size.to_digits.should eq "4.5" 
    end
  end
end
