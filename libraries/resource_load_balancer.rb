require 'poise'
require 'chef/resource'

class Chef
  class Resource::LoadBalancer < Resource
    include Poise
    provides(:load_balancer)
    actions(:create, :update, :delete)
    default_action(:create)

    attribute(:username, :kind_of => String, :required => true)
    attribute(:api_key, :kind_of => String, :required => true)
    attribute(:region, :kind_of => String, :default => 'IAD')
    attribute(:name, :name_attribute => true, :kind_of => String, :required => true)
    attribute(:protocol, :kind_of => String, :default => 'HTTP')
    attribute(:options, :kind_of => Hash, :default => {
                :port => 80,
                :algorithm => 'RANDOM',
                :timeout => 30,
                :https_redirect => false
              })
  end
end
