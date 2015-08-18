#
# Cookbook Name:: phpapp
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

include_recipe "apache2"
#include_recipe "mysql::client"
#include_recipe "mysql::server"
include_recipe "php"
include_recipe "php::module_mysql"
include_recipe "apache2::mod_php5"

apache_site "default" do
  enable true
end

mysql2_chef_gem 'default' do
  action :install
end

mysql_service 'phpapp' do
  port '3306'
  version '5.5'
  initial_root_password node['mysql']['server_root_password']
  action [:create, :start]
end
  
connection_info = {
  :host => '127.0.0.1',
  :username => 'root',
  :password => node['mysql']['server_root_password']
}

mysql_database node['phpapp']['database'] do
  connection(connection_info)
  action :create
end

mysql_database_user node['phpapp']['db_username'] do
  connection(connection_info)

  password node['phpapp']['db_password']
  database_name node['phpapp']['database']
  privileges [:select, :update, :insert, :create, :delete]
  action :grant
end

wordpress_latest = Chef::Config[:file_cache_path] + "/wordpress-latest.tar.gz"
remote_file wordpress_latest do
  source "http://wordpress.org/latest.tar.gz"
  mode "0644"
end

directory node["phpapp"]["path"] do
  owner "root"
  group "root"
  mode "0755"
  action :create
  recursive true
end

execute "untar-wordpress" do
  cwd node['phpapp']['path']
  command "tar --strip-components 1 -xzf " + wordpress_latest
  creates node['phpapp']['path'] + "/wp-settings.php"
end

