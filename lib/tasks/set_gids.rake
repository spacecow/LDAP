task :set_gids => :environment do
  Account.set_gids
end
