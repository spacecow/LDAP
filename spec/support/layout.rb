def table(row=nil, col=nil)
  table = all(:css, "table tr").map{|e| e.all(:css, "td").map(&:text)}.reject{|e| e.empty?}
end
