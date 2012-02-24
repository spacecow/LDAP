class ReportsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    redirect_to login_path and return unless current_user
    @report = Report.find(params[:id])
    stats = Dailystat.all_in_month(@report.date).where("monthstat_id is NULL")

    stats.each do |stat|
      if !stat.account.monthstats.map(&:report).include?(@report)
        monthstat = Monthstat.create!(report_id:@report.id, account_id:stat.account.id, day_of_registration:stat.account.days.order(:date).first.date, avg_account_size:stat.account_size)
        monthstat.dailystats << stat
      else
        #binding.pry
        stat.account.monthstats.select{|e| e.report==@report}.each do |monthstat|
          monthstat.recalculate_avg_account_size(stat.account_size)
          monthstat.increase_days
          monthstat.save
          stat.update_attribute(:monthstat_id,monthstat.id) 
        end
      end
    end

    @monthstats = @report.monthstats.order(sort_column+" "+sort_direction)
  end

  def index
    redirect_to login_path and return unless current_user
    months = Day.scoped.group_by{|e| e.date.strftime("%Y-%m-01")}.keys
    @reports = months.map do |month|
      Report.find_or_create_by_date(month)
    end 
  end

  private

    def sort_column
      Monthstat.column_names.include?(params[:sort]) ? params[:sort] : 'userid'
    end
    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end

end
