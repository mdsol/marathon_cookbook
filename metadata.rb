name             'marathon'
maintainer       'Medidata Solutions'
maintainer_email 'rarodriguez@mdsol.com'
license          'Apache 2.0'
description      'Installs/Configures Marathon'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '2.0.0'

%w( centos ).each do |os|
  supports os
end

# Cookbook dependencies
%w( java apt yum mesos ).each do |cb|
  depends cb
end

recommends 'zookeeper'
