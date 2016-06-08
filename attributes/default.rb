default['java']['jdk_version']            = '8'

# Marathon package
default['marathon']['version']            = '1.1.1'
default['marathon']['source']['url']      =
  "http://downloads.mesosphere.com/marathon/v#{node['marathon']['version']}/marathon-#{node['marathon']['version']}.tgz"
default['marathon']['source']['checksum'] = '35a80401383f6551c45c676beed30b3c1af6d3ad027f44735c208abe8eaca93d'
default['marathon']['syslog']             = true

# Marathon user and directories
default['marathon']['user']               = 'marathon'
default['marathon']['group']              = 'marathon'
default['marathon']['home']               = '/opt/marathon'

# JVM flags
default['marathon']['jvm']['Xmx512m']     = true

# Marathon command line flags
default['marathon']['flags']['master']    = 'zk://localhost:2181/mesos'
