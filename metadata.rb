name             'marathon'
maintainer       'Ray Rodriguez'
maintainer_email 'rayrod2030@gmail.com'
license          'Apache 2.0'
description      'Installs/Configures Apache Marathon'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.1.0'

%w( centos ubuntu ).each do |os|
  supports os
end

# Cookbook dependencies
%w( java apt yum mesos poise-service ).each do |cb|
  depends cb
end

recommends 'zookeeper'
