set :output, "cron.log"

every 1.day, :at => '2:00pm' do
  rake "generate_todays_userlist"
end
