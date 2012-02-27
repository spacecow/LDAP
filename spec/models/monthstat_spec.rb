require 'spec_helper'

describe Monthstat do
  context "#update_gids" do
    it "on existing accounts without gid" do
      report = Factory(:report)
      account = Factory(:account)
      mstat = Factory(:monthstat,report_id:report.id,account_id:account.id)
      mstat.update_attribute(:gid,'wrong')
      Monthstat.last.gid.should eq 'wrong'
      Monthstat.update_gids
      Monthstat.last.gid.should eq '1002(test)'
    end
  end
end
