task :update_account_gids => :environment do
  Account.update_gids
end

task :update_monthstat_gids => :environment do
  Monthstat.update_gids
end
