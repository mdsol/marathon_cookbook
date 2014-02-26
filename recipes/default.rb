#
# Cookbook Name:: marathon
# Recipe:: default
#
# Copyright (C) 2013 Medidata Solutions, Inc.
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe 'apt'
include_recipe 'java'
include_recipe 'runit'
include_recipe 'mesos::install'

link '/usr/lib/libmesos.so' do
  to '/usr/local/lib/libmesos.so'
end

directory node['marathon']['home_dir'] do
  owner node['marathon']['user']
  group node['marathon']['group']
  mode 00755
  recursive true
  action :create
end

directory "#{node['marathon']['home_dir']}/environment" do
  owner node['marathon']['user']
  group node['marathon']['group']
  mode 00755
  action :create
end

directory node['marathon']['config_dir'] do
  owner node['marathon']['user']
  group node['marathon']['group']
  mode 00755
  action :create
end

directory node['marathon']['log_dir'] do
  owner node['marathon']['user']
  group node['marathon']['group']
  mode 00755
  action :create
end

remote_file "#{node['marathon']['home_dir']}/marathon.jar" do
  source node['marathon']['jar_source']
  mode '0755'
  not_if { ::File.exists?("#{node['marathon']['home_dir']}/marathon.jar") }
end

command_line_options_array = []

node['marathon']['options'].each_pair do |name, option|
  command = ''
  unless option.nil?
    # Check for boolean options (ie flags with no args)
    if !!option == option
      command = "--#{name}"
    else
      command = "--#{name} #{option}"
    end
    command_line_options_array << command
  end
end

zk_server_list = []
zk_port = nil
zk_path = nil
zk_master_option = nil
zk_hosts_option = nil

if node['marathon']['zookeeper_server_list'].count > 0
  zk_server_list = node['marathon']['zookeeper_server_list']
  zk_port = node['marathon']['zookeeper_port']
  zk_path = node['marathon']['zookeeper_path']
end

if node['marathon']['zookeeper_exhibitor_discovery'] && !node['marathon']['zookeeper_exhibitor_url'].nil?
  zk_nodes = discover_zookeepers_with_retry(node['marathon']['zookeeper_exhibitor_url'])

  if zk_nodes.nil?
    Chef::Application.fatal!('Failed to discover zookeepers.  Cannot continue')
  end

  zk_server_list = zk_nodes['servers']
  zk_port = zk_nodes['port']
  zk_path = node['marathon']['zookeeper_path']
end

# ZK multi-node syntax: zk://host1:port1,host2:port2,.../path
zk_url_list = []
zk_server_list.each do |zk_server|
  zk_url_list << "#{zk_server}:#{zk_port}"
end

if zk_url_list.count > 0
  zk_master_option = "--master zk://#{zk_url_list.join(',')},/#{zk_path}"
  zk_hosts_option = "--zk_hosts #{zk_url_list.join(',')}"
end

# If we have been able to find zookeeper master endpoint and zookeeper hosts
# then set the command line options we'll be passing to runit
if !zk_master_option.nil? && !zk_hosts_option.nil?
  command_line_options_array << zk_master_option
  command_line_options_array << zk_hosts_option
else
  # if we don't have a user set master or a zk configured master
  # default to local mode.
  if node['marathon']['options']['master'].nil?
    node.override['marathon']['options']['master'] = 'local'
    command_line_options_array << '--master local'
  end
end

#if node.attribute?('ec2')
#  hostname = "--hostname #{node['ec2']['public_hostname']}"
#else
#  hostname = "--hostname #{node['ipaddress']}"
#end

#command_line_options_array << hostname

template "#{node['marathon']['config_dir']}/marathon.conf" do
  source 'marathon.conf.erb'
  owner node['marathon']['user']
  group node['marathon']['group']
  mode 00755
  variables(
    command_line_options: command_line_options_array.join(' '),
  )
  notifies :restart, 'runit_service[marathon]', :delayed
end

chef_gem 'marathon_client'

ruby_block 'block_until_operational' do
  block do
    Chef::Log.info "Waiting until Marathon is listening on port #{node['marathon']['options']['http_port']}"
    until MarathonHelper.service_listening?(node['marathon']['options']['http_port'])
      sleep 1
      Chef::Log.debug('.')
    end

    Chef::Log.info 'Waiting until the Marathon API is responding'
    test_url = URI.parse("#{node['marathon']['endpoint']}/v2/apps")
    until MarathonHelper.endpoint_responding?(test_url)
      sleep 1
      Chef::Log.debug('.')
    end
  end
  action :nothing
end

runit_service 'marathon'

log 'ensure_marathon_is_running' do
  notifies :start, 'runit_service[marathon]', :immediately
  notifies :create, 'ruby_block[block_until_operational]', :immediately
end
