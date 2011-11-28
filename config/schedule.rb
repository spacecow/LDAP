set :output, "cron.log"

every :monday, :at => '16:48pm' do
  rake "test"
end
