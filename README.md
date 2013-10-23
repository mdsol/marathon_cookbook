Description
===========

Application cookbook for installing [Mesosphere][]'s [Marathon][].
[Marathon][] is an [Apache Mesos][] framework for long-running services.


Requirements
============

Chef 11.4.0+

This cookbook also assumes you will be running a zookeeper cluster for
production use of Mesos and Marathon.  If you omit zookeeper attributes the 
cookbook does default to the internal Marathon zookeeper for test scenarios.

This cookbook also depends on the [mesosphere_mesos][] cookbook.

The following cookbooks are dependencies:

* apt
* java
* runit (process management)
* mesos (used for installing the mesos libs)
* zookeeper (used for discovering zookeeper ensembles via [Netflix Exhibitor][])

## Platform:

Tested on 

* Ubuntu 12.04

This cookbook includes cross-platform testing support via `test-kitchen`, see `TESTING.md`.


Attributes
==========

* `node['marathon']['home_dir']` - Home installation directory. Default: '/opt/marathon'.
* `node['marathon']['config_dir']` - Configuration file directory. Default: '/etc/marathon/'.
* `node['marathon']['log_dir']` - Log directory. Default: '/var/log/marathon/'.
* `node['marathon']['jar_source']` - Jar source location url.
* `node['marathon']['user']` - The user to run tasks as on mesos slaves. Default: 'root'.
* `node['marathon']['group']` - The group to run tasks as on mesos slaves. Default: 'root'.
* `node['marathon']['java_heap']` - Java heap size to assign to the marathon jvm process. Default: 
Calculated at 1/2 of node memory.

* `node['marathon']['options']['checkpoint']` - Enable checkpointing of tasks. Request checkpointing 
enabled on slaves.  Allows tasks to continue running during mesos-slave restarts and upgrades. 
Default: false.
* `node['marathon']['options']['event_subscriber']` - HTTP callback.
* `node['marathon']['options']['executor']` - Executor to use when none is specified (default = //cmd).
* `node['marathon']['options']['failover_timeout']` - The failover timeout for mesos in seconds (default: 
1 week) (default = 604800).
* `node['marathon']['options']['ha']` - Runs Marathon in HA mode with leader election. Allows 
starting an arbitrary number of other Marathons but all need to be started in HA mode. This mode requires
running ZooKeeper.
* `node['marathon']['options']['hostname']` - The advertised hostname stored in ZooKeepe so another 
standby host can redirect to this elected leader (default = localhost).
* `node['marathon']['options']['http_credentials']` - Credentials for accessing the http service.  If 
empty, anyone can access the HTTP endpoint. A username:password is expected where the username must 
not contain ':'.
* `node['marathon']['options']['http_endpoints']` - The URLs of the event endpoints master.
* `node['marathon']['options']['http_port']` - The port to listen on for HTTP requests (default = 8080).
* `node['marathon']['options']['https_port']` - The port to listen on for HTTPS requests (default = 8080).
* `node['marathon']['options']['local_port_max']` - Max port number to use when assigning port to apps
(default = 20000).
* `node['marathon']['options']['local_port_min']` - Min port number to use when assigning port to apps
(default = 10000).
* `node['marathon']['options']['log_config']` - The path to the log config.
* `node['marathon']['options']['master']` - The URL of the Mesos master.  Cookbook will default this to 
'local' if no zookeeper configuration is defined and this attribute is not set.
* `node['marathon']['options']['mesos_role']` - Mesos role for this framework.
* `node['marathon']['options']['ssl_keystore_password']` - The password for the keystore.
* `node['marathon']['options']['ssl_keystore_path']` - Provides the keystore, if supplied, SSL is enabled.
* `node['marathon']['options']['zk_hosts']` - The list of ZooKeeper servers for storing state (default 
= localhost:2181).  This cookbook will automatically populate this parameter if you define 
`node['marathon']['zookeeper_server_list']` or `node['marathon']['zookeeper_exhibitor_discovery']` and
`node['marathon']['zookeeper_exhibitor_url']` attributes.
* `node['marathon']['options']['zk_state']` - Path in ZooKeeper for storing state (default = /marathon).
* `node['marathon']['options']['zk_timeout']` - The timeout for ZooKeeper in milliseconds (default = 10000).

* `node['marathon']['zookeeper_server_list']` - List of zookeeper hostnames or IP addresses. Default: [].
* `node['marathon']['zookeeper_port']` - Mesos master zookeeper port. Default: 2181.
* `node['marathon']['zookeeper_path']` - Mesos master zookeeper path. Default: mesos.

* `node['marathon']['zookeeper_exhibitor_discovery']` - Flag to enable zookeeper ensemble discovery via 
Netflix Exhibitor. Default: false.
* `node['marathon']['zookeeper_exhibitor_url']` - Netflix Exhibitor zookeeper ensemble url.

## Usage

Here are some sample roles for configuring running marathon in internal test mode and in zookeeper backed 
production mode.

Here is a sample role for creating a marathon node with an internal zookeeper:
WARNING: Do not use this configuration for production deployments!

```YAML
chef_type:           role
default_attributes:
description:
env_run_lists:
json_class:          Chef::Role
name:                marathon
override_attributes:
  marathon:
    jar_source: 'JAR_SOURCE_URL_HERE'
  mesos:
    version: 0.14.0
run_list:
  recipe[marathon]
```

Here is a sample role for creating a marathon node with a seperate zookeeper ensemble:
NOTE: This is a recommended way to deploy marathon in production.
```YAML
chef_type:           role
default_attributes:
description:
env_run_lists:
json_class:          Chef::Role
name:                marathon
override_attributes:
  marathon:
    jar_source: 'JAR_SOURCE_URL_HERE'
    zookeeper_server_list: [ '203.0.113.2', '203.0.113.3', '203.0.113.4' ]
    zookeeper_port: 2181
    zookeeper_path: 'mesos'
  mesos:
    version: 0.14.0
run_list:
  recipe[marathon]
```

Here is a sample role for creating a marathon node with a seperate zookeeper ensemble
dynamically discovered via Netflix Exhibitor:
NOTE: This is a recommended way to deploy marathon in production.
```YAML
chef_type:           role
default_attributes:
description:
env_run_lists:
json_class:          Chef::Role
name:                marathon
override_attributes:
  marathon:
    jar_source: 'JAR_SOURCE_URL_HERE'
    zookeeper_path: 'mesos'
    zookeeper_exhibitor_discovery: true
    zookeeper_exhibitor_url: 'http://zk-exhibitor-endpoint.example.com:8080'
  mesos:
    version: 0.14.0
run_list:
  recipe[marathon]
```

[Mesosphere]: http://mesosphere.io
[mesosphere_mesos]: https://github.com/mdsol/mesos_cookbook
[marathon]: http://nerds.airbnb.com/introducing-marathon
[Apache Mesos]: http://http://mesos.apache.org
[configuring marathon]: https://github.com/airbnb/marathon/blob/master/config/README.md
[Netflix Exhibitor]: https://github.com/Netflix/exhibitor

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## Author

* Author: [Ray Rodriguez](https://github.com/rayrod2030)
