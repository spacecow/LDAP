require 'spec_helper'

describe Monthstat do
  before(:each){ @report = Factory(:report) }

  context "status, on creation" do
    it "blank if user and dir exists" do
      account = Factory(:account, path:'/home/test')
      mstat = Factory(:monthstat,report_id:@report.id,account_id:account.id)
      Monthstat.last.status.should_not be_nil
    end

    it "empty if user exists but dir does not" do
      account = Factory(:account, path:'/home/empty')
      mstat = Factory(:monthstat,report_id:@report.id,account_id:account.id)
      Monthstat.last.status.should eq 'empty' 
    end

    it "dead if user does not exist" do
      account = Factory(:account, path:'/home/ghost')
      mstat = Factory(:monthstat,report_id:@report.id,account_id:account.id)
      Monthstat.last.status.should eq 'dead' 
    end
  end

  context "#update_gids" do
    it "on existing accounts without gid" do
      account = Factory(:account, path:'/home/test')
      mstat = Factory(:monthstat,report_id:@report.id,account_id:account.id)
      mstat.update_attribute(:gid,'wrong')
      Monthstat.last.gid.should eq 'wrong'
      Monthstat.update_gids
      Monthstat.last.gid.should eq '1002(test)'
    end
  end

  context "#update statuses" do
    before(:each) do
      account = Factory(:account, path:'/home/ghost')
      mstat = Factory(:monthstat,report_id:@report.id,account_id:account.id)
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
