class DaysController < ApplicationController
  helper_method :sort_column, :sort_direction

  def show
    @day = Day.find(params[:id])
    @stats = @day.dailystats.order(sort_column+" "+sort_direction)
  end

  private

    def sort_column
      User.column_names.include?(params[:sort]) ? params[:sort] : 'account_size'
    end
    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
