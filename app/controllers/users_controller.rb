class UsersController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    userlist
    @users = User.order(sort_column+" "+sort_direction)
  end

  private

    def userlist
      path = "data/userlist.txt"
      if Rails.env == "development"
        path = "data/userlist_test.txt"
      elsif Rails.env == "test"
        path = "data/userlist_test.txt"
      elsif Rails.env == "production"
        #%x[ldapsearch -b "ou=Riec,o=TohokuUNV,c=JP" -h altair "(objectclass=*)" gecos homeDirectory > data/userlist.txt]
      else
        return false 
      end

      arr = Array.new
      File.open(path).each do |line|
        if data = line.match(/homeDirectory: (.*)/)
          if %w(development test).include?(Rails.env)
            arr.push User.find_or_create_by_path(data[1].chop)
          elsif Rails.env.production?
            arr.push User.find_or_create_by_path(data[1])
          end
        end
      end
      return arr
    end

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : 'path'
    end
    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
