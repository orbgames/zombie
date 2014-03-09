set :stage, :production
set :rails_env, "production"
set :branch, "master"

# used in case we're deploying multiple versions of the same
# app side by side. Also provides quick sanity checks when looking
# at filepaths
set :full_app_name, "#{fetch(:application)}_#{fetch(:stage)}"

set :deploy_to, "/var/www/zom/#{fetch(:stage)}"

# Simple Role Syntax
# ==================
# Supports bulk-adding hosts to roles, the primary
# server in each group is considered to be the first
# unless any hosts have the primary property set.
# Don't declare `role :all`, it's a meta role
role :app, %w{ubuntu@54.72.39.103}
role :web, %w{ubuntu@54.72.39.103}
role :db,  %w{ubuntu@54.72.39.103}

# Extended Server Syntax
# ======================
# This can be used to drop a more detailed server
# definition into the server list. The second argument
# something that quacks like a hash can be used to set
# extended properties on the server.
server '54.72.39.103', user: 'ubuntu', roles: %w{web app} #, my_property: :my_value

# whether we're using ssl or not, used for building nginx
# config file
set :enable_ssl, false

# you can set custom ssh options
# it's possible to pass any option but you need to keep in mind that net/ssh understand limited list of options
# you can see them in [net/ssh documentation](http://net-ssh.github.io/net-ssh/classes/Net/SSH.html#method-c-start)
# set it globally
 set :ssh_options, {
   # keys: %w(/home/rlisowski/.ssh/id_rsa),
   forward_agent: true,
   auth_methods: %w(publickey)
 }
# and/or per server
# server 'example.com',
#   user: 'user_name',
#   roles: %w{web app},
#   ssh_options: {
#     user: 'user_name', # overrides user setting above
#     keys: %w(/home/user_name/.ssh/id_rsa),
#     forward_agent: false,
#     auth_methods: %w(publickey password)
#     # password: 'please use keys'
#   }
# setting per server overrides global ssh_options

namespace :setup do
  task :config do
    on roles(:app) do
      execute "mkdir -p #{shared_path}/config"
      execute "mkdir -p #{shared_path}/config/nginx"
      execute "mkdir -p #{shared_path}/config/puma"
      upload! "config/deploy/nginx/#{fetch(:stage)}.conf", "#{shared_path}/config/nginx/#{fetch(:stage)}.conf"
      upload! "config/deploy/puma/#{fetch(:stage)}.rb", "#{shared_path}/config/puma/#{fetch(:stage)}.rb"
      upload! "config/deploy/database.yml.example", "#{shared_path}/config/database.yml"
      sudo "ln -nfs #{shared_path}/config/nginx/#{fetch(:stage)}.conf /etc/nginx/sites-enabled/#{fetch(:application)}_#{fetch(:stage)}.conf"
      puts "Now edit the config files in #{shared_path}."
    end
  end
end

namespace :deploy do
  desc "Make sure local git is in sync with remote."
  task :check_revision do
    on roles(:web) do
      unless `git rev-parse HEAD` == `git rev-parse origin/#{fetch(:branch)}`
        puts "WARNING: HEAD is not the same as origin/#{fetch(:branch)}"
        puts "Run `git push origin #{fetch(:branch)}` to sync changes."
        exit
      end
    end
  end
  before :deploy, "deploy:check_revision"
end