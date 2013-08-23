#
# Cookbook Name:: osrm
# Provider:: map_extract
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

def extract(exec_action)
  # create extractor.ini
  template "#{new_resource.cwd}/extractor.ini" do
    mode      00644
    owner     new_resource.user if new_resource.user
    source    'extractor.ini.erb'
    cookbook  'osrm'
    variables :memory  => new_resource.memory,
              :threads => new_resource.threads
  end

  map = [
    node['osrm']['map_path'], new_resource.region, new_resource.profile,
    ::File.basename(node['osrm']['map_data'][new_resource.region]['url']),
  ].join('/')

  directory ::File.dirname(map) do
    mode  00755
    owner new_resource.user if new_resource.user
  end

  # symlink region map to profile
  link map do
    to [ node['osrm']['map_path'], new_resource.region, ::File.basename(map) ].join('/')
  end

  # remove .osm.bpf/.osm.bz2
  map_stripped_path = map.split('.')[0..-3].join('.')

  %w{osrm osrm.names osrm.restrictions}.each do |extension|
    file "#{map_stripped_path}.#{extension}" do
      action :delete
      not_if { exec_action == :extract_if_missing }
    end
  end

  execute "osrm-#{new_resource.region}-#{new_resource.profile}-extract" do
    user    new_resource.user if new_resource.user
    cwd     new_resource.cwd  if new_resource.cwd
    command "#{new_resource.command} #{map} #{new_resource.profile_dir}/#{new_resource.profile}.lua"
    not_if  { ::File.exists?("#{map_stripped_path}.osrm.names") }
  end
end

action :extract do
  extract(:extract)
end

action :extract_if_missing do
  extract(:extract_if_missing)
end
