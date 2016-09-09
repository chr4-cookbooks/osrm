#
# Cookbook Name:: osrm
# Provider:: datastore
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
  map_dir      = new_resource.map_dir      || node['osrm']['map_dir']
  user         = new_resource.user         || node['osrm']['datastore']['user']
  shmmax       = new_resource.shmmax       || node['osrm']['shmmax']
  command      = new_resource.command      || "#{node['osrm']['target']}/build/osrm-datastore"
  map_base     = new_resource.map_base     || [
    # Concatinate path, remove .osm.bpf/.osm.bz2 file extention
    map_dir,
    new_resource.region,
    new_resource.profile,
    ::File.basename(node['osrm']['map_data'][new_resource.region]['url']),
  ].join('/').split('.')[0..-3].join('.')

  map_file = "#{map_base}.osrm"

  # Adjust shared memory limits to allow osrm-datastore to load the complete map into memory
  # See: https://github.com/Project-OSRM/osrm-backend/wiki/Configuring-and-using-Shared-Memory
  include_recipe 'sysctl'

  cmd = Mixlib::ShellOut.new('getconf PAGESIZE')
  cmd.run_command
  pagesize = cmd.stdout.to_i || 4096
  shmall = shmmax / pagesize

  sysctl_param('kernel.shmmax') { value shmmax.to_i }
  sysctl_param('kernel.shmall') { value shmall.to_i }

  # ulimit -l shmmax/1024 # 5371093
  template '/etc/security/limits.d/osrm-datastore.conf' do
    mode      0o644
    cookbook  'osrm'
    source    'limits.conf.erb'
    variables memlock: shmmax / 1024 # memlock uses KiB
  end

  execute "#{command} #{map_file}" do
    user user
    # TODO: This is pretty hacky
    # Do not execute osrm-datastore if there's an unlocked shared-memory segment of this user
    not_if "ipcs -m |grep #{user} |grep -qv locked"
  end
end
