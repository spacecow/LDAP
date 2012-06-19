require 'spec_helper'

describe "report" do
  before(:each) do
    @report = FactoryGirl.create(:report,date:Date.parse('2011-11-01'))
  end

  context "show: layout, without monthstats" do
    before(:each) do
      visit report_path(@report)
    end

    it "has a title" do
      page.should have_title('2011-11')
    end

    it "has no monthstats table" do
      page.should_not have_a_table('monthstats')
    end
  end #layout, without days

  context "show: layout, with monthstats in different reports" do
    before(:each) do
      day = FactoryGirl.create(:day, date:'2011-11-25')
      account = FactoryGirl.create(:account, path:'/home/test')
      stat = create_stat('/home/test')
      day.dailystats << stat
      mstat = FactoryGirl.create(:monthstat,report_id:@report.id,account_id:account.id,avg_account_size:12)
      mstat.dailystats << Dailystat.last 

      @report2 = FactoryGirl.create(:report,date:Date.parse('2011-12-01'))
      day2 = FactoryGirl.create(:day, date:'2011-12-20')
      day2.dailystats << create_stat('/home/test',1002,'test')
    end

    it "has a title" do
      visit report_path(@report2)
      page.should have_title('2011-12')
    end

    it "an account has a monthstat in each month" do
      lambda do
        visit report_path(@report2)
      end.should change(Monthstat,:count).by(1)
    end

    it "has rows in the table" do
      visit report_path(@report2)
      tablemap('monthstats').should eq [["test","1002","test","/home/test","1","2011-11-25"]] 
    end
  end #show: layout, with monthstats

  context "show: layout, with monthstats not reported" do
    before(:each) do
      day = FactoryGirl.create(:day, date:'2011-11-25')
      account = FactoryGirl.create(:account, path:'/home/test')
      day.dailystats << create_stat('/home/test',1002,'test')
      visit report_path(@report)
    end

    it "has a monthstats table" do
      page.should have_a_table('monthstats')
    end

    it "has a tableheader" do
      tableheader('monthstats').should eq ["Userid","GID","GName","Path","Days","Day of Registration"]
    end

    it "has rows in the table" do
      tablemap('monthstats').should eq [["test","1002","test","/home/test","1","2011-11-25"]] 
    end
  end #show: layout, with monthstats

  context "show: layout, sort on columns" do
    before(:each) do
      day = FactoryGirl.create(:day, date:'2011-11-25')
      account = FactoryGirl.create(:account, path:'/home/test')
      #day.accounts << account
      day.dailystats << create_stat('/home/test',1002,'test')
      day = FactoryGirl.create(:day, date:'2011-11-26')
      account = FactoryGirl.create(:account, path:'/home/tester')
      #day.accounts << account
      day.dailystats << create_stat('/home/tester',1004,'tester')
      visit report_path(@report)
    end

    it "has rows in the table" do
      tablemap('monthstats').should eq [["test","1002","test","/home/test","1","2011-11-25"],["tester","1004","tester","/home/tester","1","2011-11-26"]] 
    end

    it "Userid ascending (default)" do
      tablecell(0,0).should have_content("test")
      tablecell(1,0).should have_content("tester")
    end
    it "Userid descending" do
      table('monthstats').click_link "Userid"
      tablecell(0,0).should have_content("tester")
      tablecell(1,0).should have_content("test")
    end

    it "GID ascending" do
      table('monthstats').click_link "GID"
      tablecell(0,1).should have_content("1002")
      tablecell(1,1).should have_content("1004")
    end
    it "GID descending" do
      table('monthstats').click_link "GID"
      table('monthstats').click_link "GID"
      tablecell(0,1).should have_content("1004")
      tablecell(1,1).should have_content("1002")
    end

    it "GName ascending" do
      table('monthstats').click_link "GName"
      tablecell(0,2).should have_content("test")
      tablecell(1,2).should have_content("tester")
    end
    it "GName descending" do
      table('monthstats').click_link "GName"
      table('monthstats').click_link "GName"
      tablecell(0,2).should have_content("tester")
      tablecell(1,2).should have_content("test")
    end

    it "Path ascending" do
      table('monthstats').click_link "Path"
      tablecell(0,3).should have_content("/home/test")
      tablecell(1,3).should have_content("/home/tester")
    end
    it "Path descending" do
      table('monthstats').click_link "Path"
      table('monthstats').click_link "Path"
      tablecell(0,3).should have_content("/home/tester")
      tablecell(1,3).should have_content("/home/test")
    end

    it "Days ascending" do
      table('monthstats').click_link "Days"
      tablecell(0,4).should have_content("1")
      tablecell(1,4).should have_content("1")
    end
    it "Days descending" do
      table('monthstats').click_link "Days"
      table('monthstats').click_link "Days"
      tablecell(0,4).should have_content("1")
      tablecell(1,4).should have_content("1")
    end

    #it "Avg. Account Size ascending" do
    #  table('monthstats').click_link "Avg. Account Size"
    #  tablecell(0,5).should have_content("4")
    #  tablecell(1,5).should have_content("12")
    #end
    #it "Avg. Account Size descending" do
    #  table('monthstats').click_link "Avg. Account Size"
    #  table('monthstats').click_link "Avg. Account Size"
    #  tablecell(0,5).should have_content("12")
    #  tablecell(1,5).should have_content("4")
    #end

    #it "Tot. Account Size ascending" do
    #  table('monthstats').click_link "Tot. Account Size"
    #  tablecell(0,6).should have_content("4")
    #  tablecell(1,6).should have_content("12")
    #end
    #it "Tot. Account Size descending" do
    #  table('monthstats').click_link "Tot. Account Size"
    #  table('monthstats').click_link "Tot. Account Size"
    #  tablecell(0,6).should have_content("12")
    #  tablecell(1,6).should have_content("4")
    #end

    it "Day of Registration ascending" do
      table('monthstats').click_link "Day of Registration"
      tablecell(0,5).should have_content("2011-11-25")
      tablecell(1,5).should have_content("2011-11-26")
    end
    it "Day of Registration descending" do
      table('monthstats').click_link "Day of Registration"
      table('monthstats').click_link "Day of Registration"
      tablecell(0,5).should have_content("2011-11-26")
      tablecell(1,5).should have_content("2011-11-25")
    end
  end
end
