default['java']['jdk_version']            = '8'

# Marathon package
default['marathon']['version']            = '1.3.5'
default['marathon']['source']['url']      =
  "http://downloads.mesosphere.com/marathon/v#{node['marathon']['version']}/marathon-#{node['marathon']['version']}.tgz"
default['marathon']['source']['checksum'] = '298723dd54fd8c65c4cd9a052ca632a21e2d95133e328370fe2edede94a1804e'
default['marathon']['syslog']             = true

# Marathon user and directories
default['marathon']['user']               = 'marathon'
default['marathon']['group']              = 'marathon'
default['marathon']['home']               = '/opt/marathon'

# JVM flags
default['marathon']['jvm']['Xmx512m']     = true

# Marathon command line flags
default['marathon']['flags']['master']    = 'zk://localhost:2181/mesos'
