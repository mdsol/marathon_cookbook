#
# This recipe configures the Zookeeper service
#

# Configure Zookeeper
include_recipe 'zookeeper'

zk_path = ::File.join(node['zookeeper']['install_dir'], "zookeeper-#{node['zookeeper']['version']}")

poise_service 'zookeeper' do
  command "#{::File.join(zk_path, 'bin', 'zkServer.sh')} start-foreground"
  options 'upstart', template: 'zookeeper.conf.erb'
end
