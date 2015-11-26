Marathon Cookbook
=================
[![Build Status](https://secure.travis-ci.org/mdsol/marathon_cookbook.png?branch=master)](http://travis-ci.org/mdsol/marathon_cookbook)

Description
===========

Application cookbook for installing [Mesosphere][]'s [Marathon][].
[Marathon][] is an [Apache Mesos][] framework for long-running services.


Requirements
============

Chef 12.0.0+

This cookbook also assumes you will be running a zookeeper cluster for
production use of Mesos and Marathon.

This cookbook also depends on the [mesos][] cookbook.

The following cookbooks are dependencies:
* apt
* yum
* java
* upstart (process management)
* mesos (used for installing the Mesos libraries)

The following cookbooks are recommended:
* zookeeper

Newer versions of marathon will support the --disable-ha option, so the
service will not depend on zookeeper.

## Platform:

Tested on 

* CentOS 6.7

This cookbook includes cross-platform testing support via `test-kitchen`, see 
`TESTING.md`.


Attributes
==========


* `node['marathon']['version']` - Marathon version to install.
* `node['marathon']['source']['url']` - Marathon tarball URL.
* `node['marathon']['source']['checksum']` - Tarball SHA-256 checksum.

* `node['marathon']['home']` - Home installation directory. Default: '/opt/marathon'.
* `node['marathon']['user']` - The user to run tasks as on mesos slaves. Default: 'marathon'.
* `node['marathon']['group']` - The group to run tasks as on mesos slaves. Default: 'marathon'.

* `node['marathon']['jvm']['Xmx512m']` - JVM option. Default: 'true'.

* `node['marathon']['flags']['master']` - The URL of the Mesos master. Default: 'http://localhost'.

Note: Both the ['jvm'] and ['flags'] node support dynamic generation of all JVM
and Marathon command line flags. Please read the [the wrapper template](templates/default/wrapper.erb)
to see how these are generated.

## Contributing

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write your change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github

## License and Author

* Author: [Ray Rodriguez](https://github.com/rayrod2030)
* Contributor: [Mark Corwin](https://github.com/mjcdiggity)
* Contributor: [Asher Feldman](https://github.com/asher)

Copyright 2013 Medidata Solutions Worldwide

Licensed under the Apache License, Version 2.0 (the "License"); you may not use 
this file except in compliance with the License. You may obtain a copy of the 
License at

    http://www.apache.org/licenses/LICENSE-2.0

Unless required by applicable law or agreed to in writing, software distributed 
under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR 
CONDITIONS OF ANY KIND, either express or implied. See the License for the 
specific language governing permissions and limitations under the License.
