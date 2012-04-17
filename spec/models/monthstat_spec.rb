require 'spec_helper'

describe Monthstat do
  before(:each){ @report = FactoryGirl.create(:report) }

  context "on creation" do
    it "gid is set on two places" do
      account = FactoryGirl.create(:account, path:'/home/test') 
      FactoryGirl.create(:monthstat, report_id:@report.id, account_id:account.id)
      Monthstat.last.gid_num.should be(1002)
      Monthstat.last.gid_string.should eq "test"
    end

    context "status" do
      it "blank if user and dir exists" do
        account = FactoryGirl.create(:account, path:'/home/test')
        mstat = FactoryGirl.create(:monthstat,report_id:@report.id,account_id:account.id)
        Monthstat.last.status.should be_nil
      end

      it "empty if user exists but dir does not" do
        account = FactoryGirl.create(:account, path:'/home/empty')
        mstat = FactoryGirl.create(:monthstat,report_id:@report.id,account_id:account.id)
        Monthstat.last.status.should be_nil
      end

      it "dead if user does not exist" do
        account = FactoryGirl.create(:account, path:'/home/ghost')
        mstat = FactoryGirl.create(:monthstat,report_id:@report.id,account_id:account.id)
        Monthstat.last.status.should be_nil 
      end
    end
  end

  context "#update_gids" do
    it "on existing accounts without gid" do
      account = FactoryGirl.create(:account, path:'/home/test')
      mstat = FactoryGirl.create(:monthstat,report_id:@report.id,account_id:account.id)
      mstat.update_attribute(:gid_num,10)
      mstat.update_attribute(:gid_string,'wrong')
      Monthstat.last.gid_num.should eq 10 
      Monthstat.last.gid_string.should eq 'wrong'
      Monthstat.update_gids
      Monthstat.last.gid_num.should eq 1002
      Monthstat.last.gid_string.should eq 'test'
    end
  end

  context "#update statuses" do
    before(:each) do
      account = FactoryGirl.create(:account, path:'/home/ghost')
      mstat = FactoryGirl.create(:monthstat,report_id:@report.id,account_id:account.id)
      Monthstat.last.update_attribute(:status,'wrong')
    end

    it "no update on recently updated monthstats" do
      Monthstat.update_statuses
      Monthstat.last.status.should eq 'wrong'
    end

    it "update monthstats older than a day" do
      Monthstat.last.update_attribute(:updated_at,Time.now-1.day)
      Monthstat.update_statuses
      Monthstat.last.status.should eq 'dead'
    end
  end
end
