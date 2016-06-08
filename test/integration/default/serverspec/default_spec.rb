require 'serverspec'

set :backend, :exec

describe file('/opt/marathon/wrapper') do
  it { should be_file }
end

describe service('zookeeper') do
  it { should be_running }
end

describe service('mesos-master') do
  it { should be_running }
end

describe service('mesos-slave') do
  it { should be_running }
end

describe service('marathon') do
  it { should be_running }
end

require 'json'
require 'net/http'

describe 'Mesos REST API' do
  state = JSON.parse(Net::HTTP.get('localhost', '/state.json', 5050))

  it 'has an activated slave' do
    expect(state['activated_slaves']).to eq(1.0)
  end

  it 'has Marathon registered as a framework' do
    expect(state).to have_key('frameworks')
    expect(state['frameworks']).to include(include('name'=>'marathon'))
  end
end
