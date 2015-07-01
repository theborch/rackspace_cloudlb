require 'poise'
require 'chef/resource'

class Chef
  class Resource::LoadBalancerNode < Resource
    include Poise
    provides(:load_balancer_node)
    actions(:create, :update, :delete)
    default_action(:create)

    attribute(:address, :kind_of => String, :default => lazy { node['ipaddress'] }, :required => true)
    attribute(:port, :kind_of => Integer, :default => 80, :required => true)
    attribute(:options, :kind_of => Hash, :default => { :condition => 'DRAINING' })
    attribute(:load_balancer_id, :kind_of => String, :required => true)
    attribute(:username, :kind_of => String, :required => true)
    attribute(:api_key, :kind_of => String, :required => true)
    attribute(:region, :kind_of => String, :default => 'IAD')
  end
end
