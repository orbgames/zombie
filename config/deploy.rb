# config valid only for Capistrano 3.1
lock '3.1.0'

set :application, 'zom'
set :repo_url, 'git@github.com:orbgames/zombie.git'
set :deploy_user, 'ubuntu'

# Default branch is :master
ask :branch, proc { `git rev-parse --abbrev-ref HEAD`.chomp }

# Default value for :scm is :git
set :scm, :git

# Default value for :format is :pretty
set :format, :pretty

# Default value for :log_level is :debug
set :log_level, :debug

# Default value for :pty is false
# set :pty, true

# Default value for :linked_files is []
set :linked_files, %w{config/database.yml}

# Default value for linked_dirs is []
set :linked_dirs, %w{bin log tmp/pids tmp/cache tmp/sockets vendor/bundle public/system}

# Default value for default_env is {}
# set :default_env, { path: "/opt/ruby/bin:$PATH" }
set :default_env, { path: "~/.rbenv/shims:~/.rbenv/bin:$PATH" }

# Default value for keep_releases is 5
set :keep_releases, 5

# what specs should be run before deployment is allowed to
# continue, see lib/capistrano/tasks/run_tests.cap
set :tests, ["spec"]

# which config files should be copied by deploy:setup_config
# see documentation in lib/capistrano/tasks/setup_config.cap
# for details of operations
# set(:config_files, %w(
#   nginx.conf
#   application.yml
#   database.example.yml
# ))

# files which need to be symlinked to other parts of the
# filesystem. For example nginx virtualhosts, log rotation
# init scripts etc.
# set(:symlinks, [
#   {
#     source: "nginx.conf",
#     link: "/etc/nginx/sites-enabled/#{fetch(:full_app_name)}"
#   }
# ])

# this:
# http://www.capistranorb.com/documentation/getting-started/flow/
# is worth reading for a quick overview of what tasks are called
# and when for `cap stage deploy`

# namespace :deploy do
#   # make sure we're deploying what we think we're deploying
#   before :deploy, "deploy:check_revision"
#   # only allow a deploy with passing tests to deployed
#   before :deploy, "deploy:run_tests"
#   # compile assets locally then rsync
#   # after 'deploy:symlink:shared', 'deploy:compile_assets_locally'
#   after :deploy, 'symlink:shared'
#   after :finishing, 'deploy:cleanup'
# end

  # desc 'Restart application'
  # task :restart do
  #   on roles(:app), in: :sequence, wait: 5 do
  #     # Your restart mechanism here, for example:
  #     # execute :touch, release_path.join('tmp/restart.txt')
  #   end
  # end
  #
  # after :publishing, :restart
  #
  # after :restart, :clear_cache do
  #   on roles(:web), in: :groups, limit: 3, wait: 10 do
  #     # Here we can do anything such as:
  #     # within release_path do
  #     #   execute :rake, 'cache:clear'
  #     # end
  #   end
  # end

namespace :deploy do

  task :symlink_config do
    on roles(:app) do
      execute "ln -nfs #{shared_path}/config/database.yml #{release_path}/config/database.yml"
    end
  end
  after :deploy, "deploy:symlink_config"

  # task :start_monitoring, roles: :app do
  #   # execute "cd #{current_release}; bundle exec god -c  #{release_path}/config/god/#{stage}.god -D RAILS_ENV=#{stage}"
  #   set :god_port, (stage == 'production' ? 17165 : 17166)
  #   execute "cd #{current_release}; bundle exec god -c #{release_path}/config/god/#{stage}.god -P #{deploy_to}/shared/tmp/pids/god.pid -p #{god_port}"
  # end
  # after "deploy:create_symlink", "deploy:start_monitoring"

  # desc "Make sure delayed_job and clockwork is restarted"
  # task :restart_services, roles: :web do
  #   # execute "RAILS_ENV=#{stage} #{deploy_to}/current/script/delayed_job restart"
  #   execute "cd #{current_release}; RAILS_ENV=#{stage} bundle exec clockworkd --clock lib/clock.rb --pid-dir #{deploy_to}/shared/tmp/pids --log --log-dir #{deploy_to}/shared/log restart"
  # end
  # after "deploy", "deploy:restart_services"
  # after "deploy:migrations", "deploy:restart_services"

end
