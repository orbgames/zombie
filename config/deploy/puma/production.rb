environment 'production'

threads 4, 16

bind "unix:///var/www/zom/production/shared/puma.sock"
state_path  "/var/www/zom/production/shared/puma.state"
pidfile     "/var/www/zom/production/shared/puma.pid"
