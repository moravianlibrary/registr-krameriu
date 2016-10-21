lock '3.6.1'
set :application, 'registr-krameriu'
set :repo_url, 'git@github.com:moravianlibrary/registr-krameriu.git'
set :passenger_restart_with_touch, true
set :deploy_to, '/home/deploy/registr-krameriu'
append :linked_files, 'config/database.yml', 'config/secrets.yml'
append :linked_dirs, 'log', 'tmp/pids', 'tmp/cache', 'tmp/sockets', 'vendor/bundle', 'public/system'

namespace :deploy do
  desc 'Restart application'
  task :restart do
    on roles(:app), in: :sequence, wait: 5 do
      execute :touch, release_path.join('tmp/restart.txt')
    end
  end
  after :publishing, 'deploy:restart'
  after :finishing, 'deploy:cleanup'
end

namespace :seed do
  desc "Seed db"
  task :default do
    run("cd #{deploy_to}/current; /usr/bin/env bundle exec rake db:seed RAILS_ENV=#{rails_env}")
  end
end
