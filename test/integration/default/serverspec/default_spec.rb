require 'serverspec'

set :backend, :exec

describe file('/opt/marathon/wrapper') do
  it { should be_file }
end

describe service('marathon') do
  it { should be_running }
end
