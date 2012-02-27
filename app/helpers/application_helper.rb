module ApplicationHelper
  include BasicApplicationHelper

  def sortable(col, title = t(col))
    css_class = col == sort_column ? sort_direction : nil
    direction = col == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, {:sort => col, :direction => direction}, {:class => css_class}
  end

  def csv_button_to
    button_to 'CSV', report_path(1, :sort => params[:sort], :direction => params[:direction], :format => :xls)
  end
end
