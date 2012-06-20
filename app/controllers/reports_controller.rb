class ReportsController < ApplicationController
  helper_method :sort_column, :sort_direction, :account_exists?, :path_exists?

  def show
    @report = Report.find(params[:id])

    redirect_to reports_path(:start_month => @report.id, :end_month => @report.id) and return

  end

  def index
    months = Day.scoped.group_by{|e| e.date.strftime("%Y-%m-01")}.keys.sort
    @reports = months.map do |month|
      Report.find_or_create_by_date(month)
    end 

    @start_report = Report.find(params[:start_month]) unless params[:start_month].blank?
    @end_report = Report.find(params[:end_month]) unless params[:end_month].blank?

    if @start_report && @end_report

      step_date = @start_report.date
      begin
        stats = Dailystat.all_in_month(step_date).where("monthstat_id is NULL")
        until stats.empty?
          stats.shift(1000).each do |stat|
            stat.create_or_update_monthstats(Report.find_by_date(step_date))
          end
        end
        step_date += 1.month
      end while step_date <= @end_report.date

      hash = Hash[*@start_report.monthstats.map{|e| [e.path, e]}.flatten]

      step_date = @start_report.date + 1.month
      while step_date <= @end_report.date
        Report.find_by_date(step_date).monthstats.each do |new_mstat|
          if hash[new_mstat.path].nil?
            hash[new_mstat.path] = new_mstat
          else
            mstat = hash[new_mstat.path] 
            mstat.days += new_mstat.days
            mstat.gid_num = new_mstat.gid_num
            mstat.gid_string = new_mstat.gid_string
            hash[mstat.path] = mstat
          end
        end
        step_date += 1.month
      end


      @monthstats = hash.values.sort_by(&sort_column.to_sym)
      @monthstats = @monthstats.reverse if sort_direction == "desc"
    else
      @monthstats = []
    end

    respond_to do |f|
      f.html
      f.xls do
        book = Spreadsheet::Workbook.new
        sheet = book.create_worksheet :name => "LDAP"
        dead = Spreadsheet::Format.new :color => :red
        empty = Spreadsheet::Format.new :color => :orange 
        sheet.row(0).concat ["Userid","GID","GIDName","Path","Days","Avg. Account Size","Tot. Account Size","Day of Registration"]
        @monthstats.each_with_index do |mstat,i|
          #sheet.row(1+i).default_format = empty if mstat.status == 'empty' 
          #sheet.row(1+i).default_format = dead if mstat.status == 'dead'
          sheet.row(1+i).concat [mstat.userid,mstat.gid_num,mstat.gid_string,mstat.path,mstat.days,mstat.avg_account_size.to_digits.to_i,mstat.tot_account_size.to_digits.to_i,mstat.day_of_registration]
        end

        file = "private/reports/#{Date.today.strftime('%Y-%m-%d')}-report-#{@start_report.month}_#{@end_report.month}.xls" 
        book.write file
        send_file file, :content_type => "application/vnd.ms-excel",
      end
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
