module ApplicationHelper
  def sortable(col, title = col.titleize)
    css_class = col == sort_column ? sort_direction : nil
    direction = col == sort_column && sort_direction == 'asc' ? 'desc' : 'asc'
    link_to title, {:sort => col, :direction => direction}, {:class => css_class}
  end
  def title(title)
    content_for(:title){ title.to_s }
    raw "<h1>#{title}</h1>"
  end
  def subtitle(subtitle)
    raw "<h3>#{subtitle}</h3>"
  end
end
