[![Circle CI](https://circleci.com/gh/theborch/rackspace_lbaas.svg?style=svg)](https://circleci.com/gh/theborch/rackspace_lbaas)

# rackspace_lbaas

rackspace_lbaas is a Chef library cookbook to manage Rackspace cloud load balancers.

## Supported Platforms

* Ubuntu 14.04

## Usage

Place a dependency on the rackspace_cloudlb cookbook in your cookbook's metadata.rb

```
depends 'rackspace_lbaas'
```
### Examples

Create a load balancer:
```
load_balancer_node '11.22.33.44' do
  username 'kngroland'
  api_key '1122334455'
  region 'IAD'
  port '55'
  action :create
```

## Authors

Author:: Will Borchardt (will.borchardt@rackspace.com)

## License

Please refer to [LICENSE](https://github.com/theborch/rackspace_cloudlb/master/LICENSE).
