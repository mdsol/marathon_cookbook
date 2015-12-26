default['java']['jdk_version']            = '8'

# Marathon package
default['marathon']['version']            = '0.13.0'
default['marathon']['source']['url']      = "http://downloads.mesosphere.com/marathon/v#{node['marathon']['version']}/marathon-#{node['marathon']['version']}.tgz"
default['marathon']['source']['checksum'] = '224154d19679d70fb2e8e6e90c389c9542d1ece0af38be16a134e96ec587e130'
default['marathon']['syslog']             = true

# Marathon user and directories
default['marathon']['user']               = 'marathon'
default['marathon']['group']              = 'marathon'
default['marathon']['home']               = '/opt/marathon'

# JVM flags
default['marathon']['jvm']['Xmx512m']     = true

# Marathon command line flags
default['marathon']['flags']['master']    = 'zk://localhost:2181/mesos'
