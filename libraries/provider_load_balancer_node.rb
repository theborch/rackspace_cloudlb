require 'poise'
require 'chef/provider'

class Chef
  class Provider::LoadBalancerNode < Provider
    include Poise
    include RackspaceLbaasCookbook::NodeHelpers
    provides(:load_balancer_node)
    def whyrun_supported?
      true
    end

    def action_create
      converge_by("Adding node(#{new_resource.address}:#{new_resource.port}) to cloud load balancer #{new_resource.load_balancer_id}") do
        create_node(new_resource.load_balancer_id, new_resource.address, new_resource.port)
        Chef::Log.info 'Node successfully added to cloud load balancer'
      end
    end

    def action_enable
      converge_by("Enabling node(#{new_resource.address}:#{new_resource.port}) on cloud load balancer #{new_resource.load_balancer_id}") do
        update_node(new_resource.load_balancer_id, new_resource.address, new_resource.port, 'ENABLED')
        Chef::Log.info 'Node successfully enabled on cloud load balancer'
      end
    end

    def action_drain
      converge_by("Draining node(#{new_resource.address}:#{new_resource.port}) on cloud load balancer #{new_resource.load_balancer_id}") do
        update_node(new_resource.load_balancer_id, new_resource.address, new_resource.port, 'DRAINING')
        Chef::Log.info 'Node successfully draining on cloud load balancer'
      end
    end

    def action_disable
      converge_by("Disabling node(#{new_resource.address}:#{new_resource.port}) on cloud load balancer #{new_resource.load_balancer_id}") do
        update_node(new_resource.load_balancer_id, new_resource.address, new_resource.port, 'DISABLED')
        Chef::Log.info 'Node successfully disabled on cloud load balancer'
      end
    end

    def action_delete
      converge_by("Deleting node(#{new_resource.address}:#{new_resource.port}) on cloud load balancer #{new_resource.load_balancer_id}") do
        delete_node(new_resource.load_balancer_id, new_resource.address, new_resource.port)
        Chef::Log.info 'Node successfully deleted on cloud load balancer'
      end
    end
  end
end
