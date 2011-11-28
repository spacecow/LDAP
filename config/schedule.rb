set :output, "cron.log"

every :monday, :at => '16:33pm' do
  rake "test"
end
