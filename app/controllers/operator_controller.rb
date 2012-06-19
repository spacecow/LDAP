class OperatorController < ApplicationController
  helper_method :sort_column, :sort_direction

  def schema
    @days = Day.order(sort_column+" "+sort_direction)
  end

  def report
    @date = Date.parse("#{params[:date]}-01") 
    @days = Day.where("date >= :start_date and date <= :end_date", {:start_date => @date.beginning_of_month, :end_date => @date.end_of_month}) 
#    @accounts = {}
#    @days.each do |day|
#      day.dailystats.each do |stat|
#        if @accounts[stat.account.path].nil?
#          @accounts[stat.account.path] = {:days => 1} 
#          @accounts[stat.account.path][:size] = stat.account_size
#          @accounts[stat.account.path][:gid] = stat.account_gid
#          @accounts[stat.account.path][:day_of_registation] = stat.account.days.first.date
#        else
#          @accounts[stat.account.path][:days] = @accounts[stat.account.path][:days]+1 
#          @accounts[stat.account.path][:size] = @accounts[stat.account.path][:size]+stat.account_size 
#        end
#      end
#    end
#
#    respond_to do |f|
#      f.html
#      f.csv { render :layout => false } 
#    end
  end

  def reports
    @months = Day.scoped.group_by{|e| e.date.strftime("%Y-%m")}
  end

  private

    def sort_column
      Day.column_names.include?(params[:sort]) ? params[:sort] : 'date'
    end
    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
