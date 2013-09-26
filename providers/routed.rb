#
# Cookbook Name:: osrm
# Provider:: routed
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

action :create do
  # set default variables, as overridden node attributes are not available in resource
  config_dir   = new_resource.config_dir   || node['osrm']['routed']['config_dir']
  service_name = new_resource.service_name || node['osrm']['routed']['service_name']
  map_dir      = new_resource.map_dir      || node['osrm']['map_dir']
  user         = new_resource.user         || node['osrm']['routed']['user']
  home         = new_resource.home         || node['osrm']['target']
  daemon       = new_resource.daemon       || "#{node['osrm']['target']}/build/osrm-routed"
  threads      = new_resource.threads      || node['osrm']['threads']
  map_base     = new_resource.map_base     || [
    # concatinate path, remove .osm.bpf/.osm.bz2 file extention
    map_dir, new_resource.region, new_resource.profile,
    ::File.basename(node['osrm']['map_data'][new_resource.region]['url']),
  ].join('/').split('.')[0..-3].join('.')

  config_file  = "#{config_dir}/#{new_resource.region}-#{new_resource.profile}.conf"
  service_name = service_name % "#{new_resource.region}-#{new_resource.profile}"

  directory config_dir do
    mode 00755
  end

  template config_file do
    mode      00644
    source    'server.ini.erb'
    cookbook  'osrm'
    variables threads: threads,
              listen:  new_resource.listen,
              port:    new_resource.port,
              data:    "#{map_base}"
  end

  user user do
    home   home
    shell  '/bin/false'
    system true
  end


  # deploy upstart script
  template "/etc/init/#{service_name}.conf" do
    mode      00644
    source    'upstart.conf.erb'
    cookbook  'osrm'
    variables description: 'OSRM route daemon',
              daemon:      "#{daemon} #{config_file}",
              user:        user
  end

  link "/etc/init.d/#{service_name}" do
    to '/lib/init/upstart-job'
  end

  service service_name do
    supports   restart: true, status: true
    subscribes :restart, "template[#{config_file}]"
    subscribes :restart, "template[#{config_file}]"

    action [ :enable, :start ]
  end
end


action :delete do
  # set default variables, as overridden node attributes are not available in resource
  config_dir   = new_resource.config_dir   || node['osrm']['routed']['config_dir']
  service_name = new_resource.service_name || node['osrm']['routed']['service_name']

  config_file  = "#{config_dir}/#{new_resource.region}-#{new_resource.profile}.conf"
  service_name = service_name % "#{new_resource.region}-#{new_resource.profile}"

  service(service_name) { action :stop }

  file("/etc/init/#{service_name}.conf") { action :delete }
  file("/etc/init.d/#{service_name}") { action :delete }

  file(config_file) { action :delete }

  directory config_dir do
    action :delete

    # only if empty
    only_if { Dir.entries(config_dir).size == 2 }
  end
end
