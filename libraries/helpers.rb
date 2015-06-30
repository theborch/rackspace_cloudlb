module RackspaceLbaasCookbook
  module Helpers
    require 'fog'
    def lbaas
      Fog::Rackspace::LoadBalancers.new(
        :rackspace_username => new_resource.username,
        :rackspace_api_key => new_resource.api_key,
        :rackspace_region => new_resource.region,
        :rackspace_auth_url => Fog::Rackspace::US_AUTH_ENDPOINT
      )
    end

    def load_current_resource
      @current_resource = Chef::Resource::RackspaceLbaasLoadBalancerNode.new(new_resource.name)
      lb = loadbalancer
      if lb
        @current_resource.lb = lb
        @current_resource.nodes = loadbalancer_nodes
        @current_resource.node = loadbalancer_node
      else
        @current_resource
      end
    end

    def loadbalancer
      lbaas.load_balancers.get(new_resource.load_balancer_id)
      rescue Fog::Rackspace::LoadBalancers::NotFound
        raise 'Load balancer ID specified does not exist, please create load balancer and provide a valid ID'
    end

    def loadbalancer_node
      return unless @current_resource.lb && !@current_resource.nodes.empty? && check_node_exists
      node = @current_resource.nodes.map { |n| n.id if n.address == new_resource.node_address && n.port == new_resource.port }
      @current_resource.nodes.get(node[0])
    end

    def loadbalancer_nodes
      return unless @current_resource.lb
      @current_resource.lb.nodes
    end
  end
end
