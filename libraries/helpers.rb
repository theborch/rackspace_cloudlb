class StatusPendingError < StandardError
end
class StatusError < StandardError
end
module RackspaceLbaasCookbook
  def lbaas
    require 'fog'
    Fog::Rackspace::LoadBalancers.new(
      :rackspace_username => new_resource.username,
      :rackspace_api_key => new_resource.api_key,
      :rackspace_region => new_resource.region,
      :rackspace_auth_url => Fog::Rackspace::US_AUTH_ENDPOINT
    )
  end
  module NodeHelpers
    include RackspaceLbaasCookbook
    def retrieve_lb_id(name)
      @lb = lbaas.list_load_balancers.data[:body]['loadBalancers'].select { |lbs| lbs['name'] == name }.map { |lb| lb['id'] }.first
      return @lb unless @lb.nil?
    end

    def lb_status(id)
      lbaas.load_balancers.get(id).state
    end

    def check_node_exists(id, addr, port)
      @lb_node = lbaas.load_balancers.get(id).nodes.map { |n| n.id if n.address == addr && n.port == port }.compact.first
      return true unless @lb_node.nil?
    end

    def create_node(id = retrieve_lb_id, addr, port)
      return if check_node_exists(id, addr, port)
      begin
        status = lb_status(id)
        if status == 'ACTIVE'
          lbaas.create_node(id, addr, port, 'DISABLED')
        elsif status == 'PENDING_UPDATE'
          fail StatusPendingError
        else
          fail StatusError
        end
      rescue StatusPendingError
        Chef::Log.info 'Load balancer is still pending previous update, waiting 3 seconds to try again.'
        sleep 3
        retry
      rescue StatusError
        Chef::Log.error "An error occured creating the node, the load balancer status is currently #{status}"
      rescue Fog::Rackspace::LoadBalancers::ServiceError => e
        if e.to_s.include? 'Duplicate'
          Chef::Log.info 'Node already exists, moving on.'
        else
          raise "An error occured creating the node(#{addr}:#{port}) : #{e}"
        end
      end
    end

    def update_node(id = retrieve_lb_id, addr, port, condition)
      return unless check_node_exists(id, addr, port)
      begin
        status = lb_status(id)
        if status == 'ACTIVE'
          lbaas.update_node(id, @lb_node, :condition => condition)
        elsif status == 'PENDING_UPDATE'
          fail StatusPendingError
        else
          fail StatusError
        end
      rescue StatusPendingError
        Chef::Log.info 'Load balancer is still pending previous update, waiting 3 seconds to try again.'
        sleep 3
        retry
      rescue StatusError
        Chef::Log.error "An error occured enabling the node, the load balancer status is currently #{status}"
      rescue Fog::Rackspace::LoadBalancers::ServiceError => e
        raise "An error occured updating the node(#{addr}:#{port}) : #{e}"
      end
    end

    def delete_node(id = retrieve_lb_id, addr, port)
      return unless check_node_exists(id, addr, port)
      begin
        status = lb_status(id)
        if status == 'ACTIVE'
          lbaas.delete_node(id, @lb_node)
        elsif status == 'PENDING_UPDATE'
          fail StatusPendingError
        else
          fail StatusError
        end
      rescue StatusPendingError
        Chef::Log.info 'Load balancer is still pending previous update, waiting 3 seconds to try again.'
        sleep 3
        retry
      rescue StatusError
        Chef::Log.error "An error occured enabling the node, the load balancer status is currently #{status}"
      rescue Fog::Rackspace::LoadBalancers::ServiceError => e
        raise "An error occured updating the node(#{addr}:#{port}) : #{e}"
      end
    end
  end
  module LbHelpers
    include RackspaceLbaasCookbook
    def check_lb_exists(name)
      @lb = lbaas.list_load_balancers.data[:body]['loadBalancers'].select { |lbs| lbs['name'] == name }.map { |lb| lb['id'] }.first
      return true unless @lb.nil?
    end

    def create_lb(name, protocol)
      return if check_lb_exists(name)
      begin
        lbaas.create_load_balancer(name, protocol)
      rescue Fog::Rackspace::LoadBalancers::ServiceError => e
        raise "An error occured creating the load balancer (#{name}) : #{e}"
      end
    end

    def update_lb(name, protocol, options = {})
      return unless check_lb_exists(name)
      begin
        all_options = options.merge(:protocol => protocol, :name => name)
        lbaas.update_load_balancer(@lb, all_options)
      rescue Fog::Rackspace::LoadBalancers::ServiceError => e
        raise "An error occured updating the load balancer (#{name}) : #{e}"
      end
    end

    def delete_lb(name)
      return unless check_lb_exists(name)
      begin
        lbaas.delete_load_balancer(id)
      rescue Fog::Rackspace::LoadBalancers::ServiceError => e
        raise "An error occured deleting the load balancer (#{name}) : #{e}"
      end
    end
  end
end
