require 'poise'
require 'chef/resource'

class Chef
  class Resource::LoadBalancerNode < Resource
    include Poise
    resource_name(:load_balancer_node)
    allowed_actions(:create, :update, :delete)
    default_action(:create)

    attribute(:address, :name_attribute => true, :kind_of => String, :required => true)
    attribute(:port, :kind_of => Integer, :default => 80, :required => true)
    attribute(:options, :kind_of => Hash, :default => { :condition => 'DRAINING' })
    attribute(:load_balancer_id, :kind_of => String, :required => true)
    attribute(:rackspace_username, :kind_of => String, :required => true)
    attribute(:rackspace_api_key, :kind_of => String, :required => true)
  end
end
