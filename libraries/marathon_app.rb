#
# Cookbook Name:: marathon
# Library:: marathon_app
# Author:: Asher Feldman
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# rubocop:disable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
def marathon_app(app = {}, marathon_host = 'http://localhost:8080', marathon_user = nil, marathon_pass = nil)
  fail Chef::Exceptions::AttributeNotFound, 'App ID required' unless app[:id]
  fail Chef::Exceptions::AttributeNotFound, 'Command required' unless app[:command]

  # Ensure marathon_client gem installed
  marathon_client = Chef::Resource::ChefGem.new('marathon_client', run_context)
  marathon_client.version = '0.2.3'
  marathon_client.run_action(:install)

  require 'marathon'

  marathon = Marathon::Client.new(marathon_host, marathon_user, marathon_pass)

  app_opts = {
    instances: app[:instances] || 1,
    uris: app[:uri] || [],
    cmd: app[:command],
    env: app[:env] || {},
    cpus: app[:cpus] || 0.1,
    mem: app[:mem] || 10.0,
    constraints: (app[:constraint] || []).map { |c| c.split(':') },
  }
  app_opts[:executor] = app[:executor] unless app[:executor].nil?
  app_opts[:ports] = app[:ports] unless app[:ports].nil?

  res = marathon.list
  if res.success?
    res.parsed_response.each do |running|
      if running['id'] == app[:id]
        if running['cpus'] != app_opts[:cpus] || running['mem'] != app_opts[:mem] || \
        running['cmd'] != app_opts[:cmd]
          Chef::Log.info("Marathon: resource allocation or cmd changed, stopping #{app[:id]}")
          res = marathon.stop(app[:id])
          Chef::Log.info(res)
          Chef::Log.info("Marathon: starting app '#{app[:id]}'")
          res = marathon.start(app[:id], app_opts)
          Chef::Log.info(res)
          return
        end
        if running['instances'] != app_opts[:instances]
          Chef::Log.info("Need to scale #{app['id']} to #{app_opts[:instances]}")
          res = marathon.scale(app[:id], app_opts[:instances])
          Chef::Log.info(res)
          return
        end
        Chef::Log.info("#{app[:id]} already running with #{app_opts['instances']} instances")
        return
      end
    end
  end

  Chef::Log.info("Starting app '#{app[:id]}'")
  res = marathon.start(app[:id], app_opts)
  Chef::Log.info(res)
end
# rubocop:enable Metrics/CyclomaticComplexity, Metrics/PerceivedComplexity
