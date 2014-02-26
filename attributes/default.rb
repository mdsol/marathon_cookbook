default['marathon']['home_dir']                         = '/opt/marathon'
default['marathon']['config_dir']                       = '/etc/marathon'
default['marathon']['log_dir']                          = '/var/log/marathon'
default['marathon']['jar_source']                       = 'https://s3.amazonaws.com/dl.imedidata.net/marathon/marathon-0.4.1-SNAPSHOT-jar-with-dependencies.jar'
default['marathon']['user']                             = 'root'
default['marathon']['group']                            = 'root'
default['marathon']['java_heap']                        = "#{(node['memory']['total'].to_i - (node['memory']['total'].to_i / 2)) / 1024}m"

if node.attribute?('ec2')
  hostname = node['ec2']['public_hostname']
else
  hostname = node['ipaddress']
end

default['marathon']['options'].tap do |options|
  options['checkpoint']                                 = nil
  options['event_subscriber']                           = nil
  options['executor']                                   = nil
  options['failover_timeout']                           = nil
  options['ha']                                         = nil
  options['hostname']                                   = hostname
  options['http_credentials']                           = nil
  options['http_endpoints']                             = nil
  options['http_port']                                  = 8080
  options['https_port']                                 = nil
  options['local_port_max']                             = nil
  options['local_port_min']                             = nil
  options['log_config']                                 = nil
  options['master']                                     = nil
  options['mesos_role']                                 = nil
  options['ssl_keystore_password']                      = nil
  options['ssl_keystore_path']                          = nil
  options['zk_state']                                   = nil
  options['zk_timeout']                                 = nil
end

default['marathon']['zookeeper_server_list']            = []
default['marathon']['zookeeper_port']                   = 2181
default['marathon']['zookeeper_path']                   = 'mesos'

default['marathon']['zookeeper_exhibitor_discovery']    = false
default['marathon']['zookeeper_exhibitor_url']          = nil
default['marathon']['zookeeper_exhibitor_retries']      = 5

default['marathon']['process']['timeout']               = 60
default['marathon']['endpoint']                         = "http://#{default['marathon']['options']['hostname']}:#{default['marathon']['options']['http_port']}"
