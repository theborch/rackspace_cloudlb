require 'poise'
require 'chef/provider'

class Chef
  class Provider::LoadBalancerNode < Provider
    include Poise
    include ::RackspaceLbaasCookbook::Helpers

    def whyrun_supported?
      true
    end

    @loadbalancer = lbaas.load_balancers.get(new_resource.load_balancer_id)
    @nodes = @loadbalancer.nodes
    @node = @nodes.map { |n| n.id if n.address == new_resource.address && n.port == new_resource.port }.first

    def check_node_exists
      return unless @loadbalancer && !@nodes.empty?
      @nodes.map { |n| true if n.address == new_resource.address && n.port == new_resource.port }
    end

    def action_create
      return if check_node_exists
      converge_by("Adding node to cloud load balancer #{new_resource.load_balancer_id}") do
        begin
          lbaas.create_node(new_resource.load_balancer_id, new_resource.address, new_resource.port, new_resource.options[:condition])
        rescue Fog::Rackspace::LoadBalancers::ServiceError => e
          raise "An error occured making the create node request: #{e}"
        end
        Chef::Log.info 'Node successfully added to cloud loadbalancer'
      end
    end

    def action_update
      return unless check_node_exists
      converge_by("Updating node on cloud load balancer #{new_resource.load_balancer_id}") do
        begin
          lbaas.update_node(new_resource.load_balancer_id, @node, new_resource.options)
        rescue Fog::Rackspace::LoadBalancers::ServiceError => e
          raise "An error occured making the update node request: #{e}"
        end
        Chef::Log.info 'Node successfully updated on cloud loadbalancer'
      end
    end

    def action_delete
      return unless check_node_exists
      converge_by("Removing Node from cloud load balancer #{new_resource.load_balancer_id}") do
        begin
          lbaas.delete_node(new_resource.load_balancer_id, @node)
        rescue Fog::Rackspace::LoadBalancers::NotFound
          Chef::Log.info 'Node does not belong to specified load balancer ID'
        rescue Fog::Rackspace::LoadBalancers::ServiceError => e
          raise "An error occurred removing node from load balancer #{e}"
        else
          Chef::Log.info 'Node has been removed from load balancer pool'
        end
      end
    end
  end
end
