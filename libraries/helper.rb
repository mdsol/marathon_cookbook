#
# Cookbook Name:: marathon
# Library:: helper
#
# Copyright (C) 2013 Medidata Solutions, Inc.
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
require 'chef/mixin/shell_out'
require 'chef/rest'

# Helper library for testing Marathon responses
module MarathonHelper
  extend Chef::Mixin::ShellOut

  def self.service_listening?(port)
    netstat_command = 'netstat -lnt'
    cmd = shell_out!(netstat_command)
    Chef::Log.debug("`#{netstat_command}` returned: \n\n #{cmd.stdout}")
    cmd.stdout.each_line.select do |l|
      l.split[3] =~ /#{port}/
    end.any?
  end

  def self.endpoint_responding?(url)
    response = Chef::REST::RESTRequest.new(:GET, url, nil).call
    if response.kind_of?(Net::HTTPSuccess) ||
          response.kind_of?(Net::HTTPOK) ||
          response.kind_of?(Net::HTTPRedirection) ||
          response.kind_of?(Net::HTTPForbidden)
      Chef::Log.debug("GET to #{url} successful")
      return true
    else
      Chef::Log.debug("GET to #{url} returned #{response.code} / #{response.class}")
      return false
    end
  rescue EOFError, Errno::ECONNREFUSED
    Chef::Log.debug("GET to #{url} failed with connection refused")
    return false
  end

  #
  # The number of times to try to connect to exhibitor
  #
  # @return [Fixnum]
  #
  def exhibitor_retries
    node['marathon']['zookeeper_exhibitor_retries']
  end

  # Adds retry logic to exhibitor discovery
  #
  # @return [Hash]
  def discover_zookeepers_with_retry(url)
    tries ||= exhibitor_retries
    discover_zookeepers(url)
  rescue ExhibitorError
    Chef::Log.warn("Error while attempting to discover exhibitor zookeepers: Retry #{(exhibitor_retries + 1) - tries} of #{exhibitor_retries}")
    retry unless (tries -= 1).zero?
  end
end
