#
# Cookbook Name:: marathon
# Recipe:: service
#

template 'marathon-init' do
  case node['marathon']['init']
  when 'systemd'
    path '/usr/lib/systemd/system/marathon.service'
    source 'systemd.erb'
  when 'upstart'
    path   '/etc/init/marathon.conf'
    source 'upstart.erb'
  when 'sysvinit_debian'
    path '/etc/init.d/marathon'
    source 'sysvinit_debian.erb'
  end
  variables(wrapper: ::File.join(node['marathon']['home'], 'wrapper'),
            user:    node['marathon']['user'])
end

service 'marathon' do
  case node['marathon']['init']
  when 'systemd'
    provider Chef::Provider::Service::Systemd
  when 'sysvinit_debian'
    provider Chef::Provider::Service::Init::Debian
  when 'upstart'
    provider Chef::Provider::Service::Upstart
  end
  supports   status: true, restart: true
  subscribes :stop, 'template[marathon-init]', :immediately
  subscribes :start, 'template[marathon-init]', :immediately
  action     [:enable, :start]
end
