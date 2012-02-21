class OperatorController < ApplicationController
  helper_method :sort_column, :sort_direction

  def schema
    redirect_to login_path and return unless current_user
    @days = Day.order(sort_column+" "+sort_direction)
  end

  def report
    redirect_to login_path and return unless current_user
    @date = Date.parse("#{params[:date]}-01") 
    @days = Day.where("date >= :start_date and date <= :end_date", {:start_date => @date.beginning_of_month, :end_date => @date.end_of_month}) 
    @accounts = {}
    @days.each do |day|
      day.dailystats.each do |stat|
        if @accounts[stat.account.path].nil?
          @accounts[stat.account.path] = {:days => 1} 
          @accounts[stat.account.path][:size] = stat.account_size
        else
          @accounts[stat.account.path][:days] = @accounts[stat.account.path][:days]+1 
          @accounts[stat.account.path][:size] = @accounts[stat.account.path][:size]+stat.account_size 
        end
      end
    end
  end

  def reports
    redirect_to login_path and return unless current_user
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
