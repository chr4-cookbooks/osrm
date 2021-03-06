#
# Cookbook Name:: osrm
# Provider:: map_contract
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

action :contract do
  # Set default variables, as overridden node attributes are not available in resource
  map_dir     = new_resource.map_dir     || node['osrm']['map_dir']
  command     = new_resource.command     || "#{node['osrm']['target']}/build/osrm-contract"
  cwd         = new_resource.cwd         || "#{node['osrm']['target']}/build"
  threads     = new_resource.threads     || node['osrm']['threads']
  map         = new_resource.map         || node['osrm']['map_data'][new_resource.region]['url']

  # Use map_dir + profile name as output path, remove .osm.bpf/.osm.bz2
  map_stripped_path = [
    map_dir, new_resource.region, new_resource.profile, ::File.basename(map)
  ].join('/').split('.')[0..-3].join('.')

  execute "osrm-#{new_resource.region}-#{new_resource.profile}-contract" do
    user    new_resource.user if new_resource.user
    cwd     cwd
    timeout new_resource.timeout
    command "#{command} #{map_stripped_path}.osrm -t #{threads}"
    not_if  { ::File.exist?("#{map_stripped_path}.osrm.hsgr") }
  end

  # Cleanup previously extracted files (not needed anymore)
  # using rm -f, as file provider is really slow when deleting big files
  return unless new_resource.cleanup
  execute "rm -f #{map_stripped_path}.osrm"
  execute "rm -f #{map_stripped_path}.osrm.restrictions"
end
