[![Circle CI](https://circleci.com/gh/theborch/rackspace_lbaas.svg?style=svg)](https://circleci.com/gh/theborch/rackspace_lbaas)

# rackspace_lbaas

rackspace_lbaas is a Chef library cookbook to manage Rackspace cloud load balancers.

## Supported Platforms

* Ubuntu 14.04

## Usage

Place a dependency on the rackspace_cloudlb cookbook in your cookbook's metadata.rb:

```
depends 'rackspace_lbaas'
```

Add the default recipe to your run list:

```
  recipe[rackspace_lbaas]
```

Or include it in your recipe:

```
  include_recipe 'rackspace_lbaas'
```

### Examples

Create a new lode balancer node:

```
load_balancer_node 'spcblls-01' do
  username 'kngroland'
  api_key '1122334455'
  load_balancer_id '12345'
  action :create
end
```

Change the condition of a load balancer node:

```
load_balancer_node 'spcblls-01' do
  username 'kngroland'
  api_key '1122334455'
  load_balancer_id '12345'
  action :drain
end
```

Delete a load balancer node:

```
load_balancer_node 'spcblls-01' do
  username 'kngroland'
  api_key '1122334455'
  load_balancer_id '12345'
  action :delete
end
```

Create a new lode balancer:

```
load_balancer 'spcblls-01' do
  username 'kngroland'
  api_key '1122334455'
end
```

Update a load balancer:

```
load_balancer 'spcblls-01' do
  username 'kngroland'
  api_key '1122334455'
  protocol 'HTTPS'
  port 443
  action :update
end
```

Delete a load balancer:

```
load_balancer 'spcblls-01' do
  username 'kngroland'
  api_key '1122334455'
  action :delete
end
```

## Authors

Author:: Will Borchardt (will.borchardt@rackspace.com)

## License

Please refer to [LICENSE](https://github.com/theborch/rackspace_cloudlb/master/LICENSE).
