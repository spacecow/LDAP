default_run_options[:pty] = true
set :repository,  "git@github.com:spacecow/LDAP.git"
set :scm, "git"
set :branch, "master"
set :deploy_via, :remote_cache
set :use_sudo, false

set :application, "LDAP"
set :deploy_to, "/home/www/apps/#{application}"
set :user, "jsveholm"
set :admin_runner, "jsveholm"
  
role :app, "www.riec.tohoku.ac.jp"
role :web, "www.riec.tohoku.ac.jp"
role :db,  "www.riec.tohoku.ac.jp", :primary => true

set :default_environment, { 
  'PATH' => "/opt/local/csw/bin:/opt/local/bin:/opt/csw/bin:/usr/bin:/usr/local/bin"
}

namespace :deploy do
  task :start do ; end
  task :stop do ; end
  task :restart, :roles => :app, :except => { :no_release => true } do
    run "#{try_sudo} touch #{File.join(current_path,'tmp','restart.txt')}"
  end
  task :symlink_shared do
    run "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
  end
end

namespace :delayed_job do 
    desc "Restart the delayed_job process"
    task :restart, :roles => :app do
        run "cd #{current_path}; RAILS_ENV=#{rails_env} script/delayed_job restart"
    end
end

after 'deploy:update_code', 'deploy:symlink_shared' #, "delayed_job:restart"
