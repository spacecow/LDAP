task :update_account_gids => :environment do
  Account.update_gids
end

task :update_monthstat_gids => :environment do
  Monthstat.update_gids
end

#Migrate the pids to the dailystats
#----------------------------------

#Check to see that all the accounts are of format 1(ghost)
task :check_account_gids => :environment do
  Account.check_gids
end

#Check to see that all the dailystats have an account
task :check_dailystat_accounts => :environment do
  Dailystat.check_accounts
end
 


