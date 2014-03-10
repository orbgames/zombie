environment 'production'

threads 4, 16

bind "unix:///var/www/zom/production/shared/tmp/sockets/puma.sock"
state_path  "/var/www/zom/production/shared/tmp/pids/puma.state"
pidfile     "/var/www/zom/production/shared/tmp/pids/puma.pid"
