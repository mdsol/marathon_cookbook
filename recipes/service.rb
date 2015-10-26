#
# Cookbook Name:: marathon
# Recipe:: service
#

template 'marathon-init' do
  case node['marathon']['init']
  when 'systemd'
    path '/usr/lib/systemd/system/mesos-slave.service'
    source 'systemd.erb'
  when 'upstart'
    path   '/etc/init/marathon.conf'
    source 'upstart.erb'
  when 'sysvinit_debian'
    path '/etc/init.d/mesos-slave'
    source 'sysvinit_debian.erb'
  variables(wrapper: ::File.join(node['marathon']['home'], 'wrapper'))
end

# service 'marathon-default' do
#   case node['marathon']['init']
#   when 'systemd'
#     provider Chef::Provider::Service::Systemd
#   when 'sysvinit_debian'
#     provider Chef::Provider::Service::Init::Debian
#   when 'upstart'
#     provider Chef::Provider::Service::Upstart
#   end
#   action [:stop, :disable]
# end
