include_recipe 'marathon'

# Register a simple marathon application
test_app = {
  id: 'test_app',
  command: '/usr/bin/echo "hello world"',
  instances: 3,
  cpus: 0.25,
  mem: 125,
  env: { foo: 'bar' },
  constraint: [ 'hostname:UNIQUE', 'rack:GROUP_BY' ]
}

marathon_app(test_app)
