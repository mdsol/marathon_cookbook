#
# Cookbook Name:: marathon
# Recipe:: service
#

template 'marathon-init' do
  path   '/etc/init/marathon.conf'
  source 'upstart.erb'
  variables(wrapper: ::File.join(node['marathon']['home'], 'wrapper'))
end
