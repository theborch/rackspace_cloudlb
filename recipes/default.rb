# Encoding: utf-8
#
# Cookbook Name:: rackspace_lbaas
# Recipe:: default
#
# Copyright 2014, Rackspace
#
chef_gem 'fog' do
  action :install
end
