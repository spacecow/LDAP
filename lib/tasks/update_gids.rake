task :update_gids => :environment do
  Account.update_gids
end
