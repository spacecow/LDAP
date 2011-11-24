class UsersController < ApplicationController
  def index
    @users = userlist
  end

  private

    def userlist
      path = "data/userlist.txt"
      if Rails.env == "development"
      elsif Rails.env == "test"
        path = "data/userlist_test.txt"
      elsif Rails.env == "production"
        %x[ldapsearch -b "ou=Riec,o=TohokuUNV,c=JP" -h altair "(objectclass=*)"
gecos homeDirectory > data/userlist.txt]
      else
        return false 
      end

      arr = Array.new
      File.open(path).each do |line|
        if data = line.match(/homeDirectory: (.*)/)
          arr.push User.new(:path => data[1].chop)
        end
      end
      return arr
    end
end
