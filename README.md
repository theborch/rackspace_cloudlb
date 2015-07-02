[![Circle CI](https://circleci.com/gh/theborch/rackspace_lbaas.svg?style=svg)](https://circleci.com/gh/theborch/rackspace_lbaas)

# rackspace_lbaas

rackspace_lbaas is a Chef library cookbook to manage Rackspace cloud load balancers.

## Supported Platforms

* Ubuntu 14.04

## Usage

Place a dependency on the rackspace_cloudlb cookbook in your cookbook's metadata.rb:
```ruby
depends 'rackspace_lbaas'
```

Add the default recipe to your run list:
```ruby
...
  recipe[rackspace_lbaas]
...
```

Or include it in your recipe:
```ruby
  include_recipe 'rackspace_lbaas'
```

### Examples

Create a new lode balancer node:
```ruby
load_balancer_node 'spcblls-01' do
  username 'kngroland'
  api_key '1122334455'
  load_balancer_id '12345'
  action :create
end
```

Change the condition of a load balancer node:
```ruby
load_balancer_node 'spcblls-01' do
  username 'kngroland'
  api_key '1122334455'
  load_balancer_id '12345'
  action :drain
end
```

Delete a load balancer node:
```ruby
load_balancer_node 'spcblls-01' do
  username 'kngroland'
  api_key '1122334455'
  load_balancer_id '12345'
  action :delete
end
```
## Authors

Author:: Will Borchardt (will.borchardt@rackspace.com)

## License

Please refer to [LICENSE](https://github.com/theborch/rackspace_cloudlb/master/LICENSE).
