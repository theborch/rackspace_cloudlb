require 'poise'
require 'chef/provider'

class Chef
  class Provider::LoadBalancer < Provider
    include Poise
    include RackspaceLbaasCookbook::LbHelpers
    provides(:load_balancer)
    def whyrun_supported?
      true
    end

    def action_create
      converge_by("Creating cloud load balancer #{new_resource.name}") do
        create_lb(new_resource.name, new_resource.protocol)
        Chef::Log.info 'Cloud load balancer successfully created'
      end
    end

    def action_update
      converge_by("Updating cloud load balancer #{new_resource.name}") do
        update_lb(new_resource.name, new_resource.protocol, new_resource.options)
        Chef::Log.info 'Cloud load balancer successfully updated'
      end
    end

    def action_delete
      converge_by("Deleting cloud load balancer #{new_resource.name}") do
        delete_lb(new_resource.name)
        Chef::Log.info 'Cloud load balancer successfully deleted'
      end
    end
  end
end
