#
# Cookbook Name:: marathon
# Recipe:: install
#

include_recipe 'java'
include_recipe 'mesos'

poise_service_user node['marathon']['user'] do
  group node['marathon']['group']
  home node['marathon']['home']
end

directory node['marathon']['home'] do
  owner     node['marathon']['user']
  group     node['marathon']['group']
  mode      '0755'
  recursive true
end

pkg_location = ::File.join(Chef::Config[:file_cache_path], 'marathon.tgz')

remote_file 'marathon-pkg' do
  path     pkg_location
  source   node['marathon']['source']['url']
  checksum node['marathon']['source']['checksum']
end

execute 'marathon-extract' do
  user    node['marathon']['user']
  group   node['marathon']['group']
  command "/bin/tar -xf #{pkg_location} -C #{node['marathon']['home']}"
  only_if { ::Dir.glob("#{node['marathon']['home']}/*#{node['marathon']['version']}").empty? }
end

template 'marathon-wrapper' do
  path     ::File.join(node['marathon']['home'], 'wrapper')
  owner    'root'
  group    'root'
  mode     '0755'
  source   'wrapper.erb'
  variables(lazy do
    { jar:    ::Dir.glob("#{node['marathon']['home']}/*#{node['marathon']['version']}/target/*/*.jar").first.to_s,
      jvm:    node['marathon']['jvm'],
      flags:  node['marathon']['flags'],
      syslog: node['marathon']['syslog'] }
  end)
end
