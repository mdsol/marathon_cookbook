#
# Cookbook Name:: marathon
# Recipe:: service
#

template 'marathon-init' do
  path   '/etc/init/marathon.conf'
  source 'upstart.erb'
  variables(wrapper: ::File.join(node['marathon']['home'], 'wrapper'),
            user:    node['marathon']['user'])
end

service 'marathon' do
  provider   Chef::Provider::Service::Upstart
  supports   status: true, restart: true
  subscribes :stop, 'template[marathon-init]'
  subscribes :start, 'template[marathon-init]'
  action     [:enable, :start]
end
