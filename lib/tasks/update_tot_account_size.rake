task :update_tot_account_size => :environment do
  Monthstat.update_tot_account_size
end
