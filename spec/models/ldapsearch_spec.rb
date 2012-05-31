require 'spec_helper'

describe Ldapsearch do
  describe "group_hash" do
    it "returns a hash" do
      hash = Ldapsearch.group_hash
      hash.length.should be(78)
    end
  end

  describe "read" do
    it "initializes the dailystats" do
      hash = Ldapsearch.group_hash
      lambda{ Ldapsearch.read(hash)
      }.should change(Dailystat,:count).by(529)
      Dailystat.first.gid_num.should be(155)
      Dailystat.first.gid_string.should eq('otsuji')
    end
  end

  describe "#people_match" do
    context "matches" do
      it 'people' do
        Ldapsearch.people_match('ou=people')[0].should eq('ou=people') 
      end
      it 'People' do
        Ldapsearch.people_match('ou=People')[0].should eq('ou=People') 
      end
      it '"people"' do
        Ldapsearch.people_match('ou="people"')[0].should eq('ou="people"') 
      end
      it '"People"' do
        Ldapsearch.people_match('ou="People"')[0].should eq('ou="People"') 
      end
    end
  end
end
