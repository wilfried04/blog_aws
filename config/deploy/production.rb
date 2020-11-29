server '34.200.194.143', user:'app', roles: %w{app db web} 
 set :ssh_options, keys:'/home/wilromeo/.ssh/id_rsa'