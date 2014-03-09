environment 'staging'

threads 4, 16

bind "unix:///var/www/zom/shared/tmp/sockets/puma_staging.sock"
state_path  "/var/www/zom/shared/tmp/sockets/puma_staging.state"
pidfile     "/var/www/zom/shared/tmp/pids/puma_staging.pid"
