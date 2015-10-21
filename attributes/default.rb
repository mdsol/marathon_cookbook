default['java']['jdk_version']            = '8'

# Marathon package
default['marathon']['version']            = '0.11.0'
default['marathon']['source']['url']      = 'http://downloads.mesosphere.com/marathon/v0.11.0/marathon-0.11.0.tgz'
default['marathon']['source']['checksum'] = 'e6c9de73e6fb9ce7b3ff53ab706bbd427f4479dfce4172c983ff13f7330f600e'

# Marathon user and directories
default['marathon']['user']               = 'marathon'
default['marathon']['group']              = 'marathon'
default['marathon']['home']               = '/opt/marathon'

# JVM flags
default['marathon']['jvm']['Xmx512m']     = true

# Marathon command line flags
default['marathon']['flags']['master']    = 'http://localhost'
