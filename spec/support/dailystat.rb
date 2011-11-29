def create_stat(path,size=0)
  Dailystat.create(:account_size => size, :path => path)
end
