class OperatorController < ApplicationController
  helper_method :sort_column, :sort_direction

  def schema
    @days = Day.order(sort_column+" "+sort_direction)
  end

  private

    def sort_column
      Day.column_names.include?(params[:sort]) ? params[:sort] : 'date'
    end
    def sort_direction
      %w(asc desc).include?(params[:direction]) ? params[:direction] : 'asc'
    end
end
