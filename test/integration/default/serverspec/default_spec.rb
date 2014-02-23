require_relative '../../../kitchen/data/spec_helper'

# make sure libmesos.so is linked
describe file('/usr/lib/libmesos.so') do
  it { should be_file }
  it { should be_linked_to '/usr/local/lib/libmesos.so' }
end

describe file('/etc/marathon/marathon.conf') do
  it { should be_file }
end

describe 'marathon service' do
  it 'should be enabled and running' do
    expect(service 'marathon').to be_running
  end
end

describe port(8080) do
  it { should be_listening }
end
