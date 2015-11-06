#
# This recipe configures the Zookeeper service
#

# Configure Zookeeper
include_recipe 'zookeeper'

zk_path = ::File.join(node['zookeeper']['install_dir'], "zookeeper-#{node['zookeeper']['version']}")

# Configure the Zookeeper service
template 'zookeeper-upstart' do
  path     '/etc/init/zookeeper.conf'
  source   'zookeeper.conf.erb'
  variables(bin: ::File.join(zk_path, 'bin', 'zkServer.sh'))
  action   :create
  notifies :stop,  'service[zookeeper]', :immediately
  notifies :start, 'service[zookeeper]', :immediately
end

service 'zookeeper' do
  provider   Chef::Provider::Service::Upstart
  action     [:enable, :start]
  subscribes :restart, "zookeeper_config[#{zk_path}/conf/zoo.cfg]", :delayed
end
