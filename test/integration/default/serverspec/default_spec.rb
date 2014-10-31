require 'serverspec'

set :backend, :exec

# marathon service
describe file('/usr/local/lib/libmesos.so') do
  it { should be_file }
end

describe file('/usr/lib/libmesos.so') do
  it { should be_file }
end

describe file('/etc/marathon/marathon.conf') do
  it { should be_file }
end

describe service('marathon') do
  it { should be_running }
end
