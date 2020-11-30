$worker  = 2
$timeout = 30
#Your application name (note that current is included)
$app_dir = "/var/www/blog/current"
$listen  = File.expand_path 'tmp/sockets/unicorn.sock', $app_dir
$pid     = File.expand_path 'tmp/pids/unicorn.pid', $app_dir
$std_log = File.expand_path 'log/unicorn.log', $app_dir
# Defined so that what is Settings above is applied
worker_processes  $worker
working_directory $app_dir
stderr_path $std_log
stdout_path $std_log
timeout $timeout
listen  $listen
pid $pid
preload_app true
before_fork do |undefined, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.connection.disconnect
  old_pid = "#{undefined.config[:pid]}.oldbin"
  if old_pid != undefined.pid
    begin
      Process.kill "QUIT", File.read(old_pid).to_i
    rescue Errno::ENOENT, Errno::ESRCH
    end
  end
end
after_fork do |undefined, worker|
  defined?(ActiveRecord::Base) and ActiveRecord::Base.establish_connection
end