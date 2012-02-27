class ReportsController < ApplicationController
  helper_method :sort_column, :sort_direction, :account_exists?, :path_exists?

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

    respond_to do |f|
      f.html
      f.xls do
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet :name => "LDAP"
        dead = Spreadsheet::Format.new :color => :red
        empty = Spreadsheet::Format.new :color => :orange 
        sheet.row(0).concat ["Userid","GID","Path","Days","Avg. Account Size", "Day of Registration"]
        @monthstats.each_with_index do |mstat,i|
          sheet.row(1+i).default_format = empty if mstat.status == 'empty' 
          sheet.row(1+i).default_format = dead if mstat.status == 'dead'
          sheet.row(1+i).concat [mstat.userid,mstat.gid,mstat.path,mstat.days,mstat.avg_account_size.to_digits.to_i,mstat.day_of_registration]
        end

        file = "private/reports/#{Date.today.strftime('%Y-%m-%d')}-report-#{@report.date.strftime('%Y-%m')}.xls" 
        book.write file
        send_file file, :content_type => "application/vnd.ms-excel",
      end
    end
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
