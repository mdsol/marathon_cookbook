#
# Cookbook Name:: marathon
# Recipe:: service
#

default['marathon']['init'] = case node['platform']
                              when 'ubuntu' then
                                if node['platform_version'] > '14.04'
                                  'systemd'
                                else
                                  'upstart'
                                end
                              else
                                'upstart'
                              end

case node['marathon']['init']
when 'systemd'

  template 'marathon-service' do
    path '/lib/systemd/system/marathon.service'
    source 'marathon.service.erb'
    variables(wrapper: ::File.join(node['marathon']['home'], 'wrapper'),
              user:    node['marathon']['user'])
  end

  service 'marathon' do
    provider  Chef::Provider::Service::Systemd
    supports  status: true, restart: true
    subscribes :stop, 'template[marathon-service]'
    subscribes :start, 'template[marathon-service]'
    action     [:enable, :start]
  end

else

  template 'marathon-init' do
    path   '/etc/init/marathon.conf'
    source 'upstart.erb'
    variables(wrapper: ::File.join(node['marathon']['home'], 'wrapper'),
              user:    node['marathon']['user'])
  end

  service 'marathon' do
    provider   Chef::Provider::Service::Upstart
    supports   status: true, restart: true
    subscribes :stop, 'template[marathon-init]'
    subscribes :start, 'template[marathon-init]'
    action     [:enable, :start]
  end

end
