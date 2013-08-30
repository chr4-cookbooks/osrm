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
  config_file  = "#{new_resource.config_dir}/#{new_resource.region}-#{new_resource.profile}.conf"
  service_name = new_resource.service_name % "#{new_resource.region}-#{new_resource.profile}"

  directory new_resource.config_dir do
    mode 00755
  end

  map = [
    node['osrm']['map_path'], new_resource.region, new_resource.profile,
    ::File.basename(node['osrm']['map_data'][new_resource.region]['url']),
  ].join('/')

  # remove .osm.bpf/.osm.bz2
  map_stripped_path = map.split('.')[0..-3].join('.')

  template config_file do
    mode      00644
    source    'server.ini.erb'
    cookbook  'osrm'
    variables threads: new_resource.threads,
              listen:  new_resource.listen,
              port:    new_resource.port,
              data:    "#{map_stripped_path}"
  end

  user new_resource.user do
    home   new_resource.home
    shell  '/bin/false'
    system true
  end


  # deploy upstart script
  template "/etc/init/#{service_name}.conf" do
    mode      00644
    source    'upstart.conf.erb'
    cookbook  'osrm'
    variables :description => 'OSRM route daemon',
              :daemon      => "#{new_resource.daemon} #{config_file}",
              :user        => new_resource.user
  end

  link "/etc/init.d/#{service_name}" do
    to '/lib/init/upstart-job'
  end

  service service_name do
    supports :restart => true
    subscribes :restart, "template[#{config_file}]"
    subscribes :restart, "template[#{config_file}]"

    action [ :enable, :start ]
  end
end


action :delete do
  config_file  = "#{new_resource.config_dir}/#{new_resource.region}-#{new_resource.profile}.conf"
  service_name = new_resource.service_name % "#{new_resource.region}-#{new_resource.profile}"

  service(service_name) { action :stop }

  file("/etc/init/#{service_name}.conf") { action :delete }
  file("/etc/init.d/#{service_name}") { action :delete }
end
