#
# Cookbook Name:: osrm
# Provider:: node
#
# Copyright 2012, Chris Aumann
#
# This program is free software: you can redistribute it and/or modify
# it under the terms of the GNU General Public License as published by
# the Free Software Foundation, either version 3 of the License, or
# (at your option) any later version.
#
# This program is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
# GNU General Public License for more details.
#
# You should have received a copy of the GNU General Public License
# along with this program.  If not, see <http://www.gnu.org/licenses/>.
#

use_inline_resources

action :create do
  # Set default variables, as overridden node attributes are not available in resource
  service_name = new_resource.service_name || node['osrm']['node']['service_name']
  map_dir      = new_resource.map_dir      || node['osrm']['map_dir']
  user         = new_resource.user         || node['osrm']['node']['user']
  app_dir      = new_resource.app_dir      || node['osrm']['node']['app_dir']
  map_base     = new_resource.map_base     || [
    # Concatinate path, remove .osm.bpf/.osm.bz2 file extention
    map_dir,
    new_resource.region,
    new_resource.profile,
    ::File.basename(node['osrm']['map_data'][new_resource.region]['url']),
  ].join('/').split('.')[0..-3].join('.')

  service_name = service_name % "#{new_resource.region}-#{new_resource.profile}"
  map_file = "#{map_base}.osrm"

  execute 'npm install' do
    # npm saves stuff to ~/.npm
    env   'HOME' => "/home/#{user}"
    user   user
    cwd    app_dir
    action :nothing
  end

  # Create application directory, deploy application files
  directory app_dir do
    mode  00755
    owner user
  end

  template "#{app_dir}/package.json" do
    owner    user
    source   'node-osrm/package.json'
    cookbook 'osrm'
    notifies :run, 'execute[npm install]', :immediately
  end

  template "#{app_dir}/server.js" do
    owner     user
    source    'node-osrm/server.js.erb'
    cookbook  'osrm'
    variables listen: new_resource.listen,
              port: new_resource.port,
              shared_memory: new_resource.shared_memory,
              map: map_file
  end

  # Deploy upstart script
  template "/etc/init/#{service_name}.conf" do
    mode      00644
    source    'upstart.conf.erb'
    cookbook  'osrm'
    variables description: 'OSRM node.js daemon',
              user:        user,
              chdir:       app_dir,
              daemon:      new_resource.daemon
  end

  link "/etc/init.d/#{service_name}" do
    to '/lib/init/upstart-job'
  end

  service service_name do
    supports   restart: true, status: true
    subscribes :restart, "template[/etc/init/#{service_name}.conf]"

    action [:enable, :start]
  end
end

action :delete do
  # Set default variables, as overridden node attributes are not available in resource
  service_name = new_resource.service_name || node['osrm']['node']['service_name']

  service_name = service_name % "#{new_resource.region}-#{new_resource.profile}"

  service(service_name) { action :stop }

  file("/etc/init/#{service_name}.conf") { action :delete }
  file("/etc/init.d/#{service_name}") { action :delete }
end
