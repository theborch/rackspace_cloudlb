require 'poise'
require 'chef/provider'

class Chef
  class Provider::LoadBalancerNode < Provider
    include Poise
    include RackspaceLbaasCookbook::Helpers

    def whyrun_supported?
      true
    end

    def check_node_exists
      return unless @current_resource.lb && !@current_resource.nodes.empty?
      @current_resource.nodes.map { |node| true if node.address == new_resource.node_address && node.port == new_resource.port }
    end

    def action_create_node
      return if check_node_exists
      converge_by("Adding node to cloud load balancer #{new_resource.load_balancer_id}") do
        begin
          lbaas.create_node(new_resource.load_balancer_id, new_resource.node_address, new_resource.port, new_resource.options[:condition])
        rescue Fog::Rackspace::LoadBalancers::ServiceError => e
          raise "An error occured making the create node request: #{e}"
        end
        Chef::Log.info 'Node successfully added to cloud loadbalancer'
      end
    end

    def action_update_node
      return unless check_node_exists
      converge_by("Updating node on cloud load balancer #{new_resource.load_balancer_id}") do
        begin
          lbaas.update_node(new_resource.load_balancer_id, @current_resource.node, new_resource.options)
        rescue Fog::Rackspace::LoadBalancers::ServiceError => e
          raise "An error occured making the update node request: #{e}"
        end
        Chef::Log.info 'Node successfully updated on cloud loadbalancer'
      end
    end

    def action_delete_node
      return unless check_node_exists
      converge_by("Removing Node from cloud load balancer #{new_resource.load_balancer_id}") do
        begin
          lbaas.delete_node(new_resource.load_balancer_id, @current_resource.node_id)
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
