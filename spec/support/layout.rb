def table(row=nil, col=nil)
  table = all(:css, "table tr").map{|e| e.all(:css, "td").map(&:text)}.reject{|e| e.empty?}
  return table if row.nil?
  return table[row] if col.nil?
  return table[row][col]
end
