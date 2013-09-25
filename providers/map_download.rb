#
# Cookbook Name:: osrm
# Provider:: map_download
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

def download(exec_action)
  # set default variables, as overridden node attributes are not available in resource
  map_dir = new_resource.map_dir || node['osrm']['map_dir']
  url     = new_resource.url     || node['osrm']['map_data'][new_resource.region]['url']

  path = "#{map_dir}/#{new_resource.region}/#{::File.basename(url)}"

  directory ::File.dirname(path) do
    mode      00755
    owner     new_resource.user if new_resource.user
    recursive true
  end

  remote_file path do
    owner    new_resource.user if new_resource.user
    source   url
    backup   false

    case new_resource.checksum
    when false
      # deactivate checksum checking, when checksum is set to false
      my_checksum = nil
    when true
      # use the default checksum when checksum is set to true
      my_checksum = node['osrm']['map_data'][new_resource.region]['checksum']
    else
      # checksum was manually specified
      my_checksum = new_resource.checksum
    end

    # when checksum is a URL, use curl to get its content
    if my_checksum =~ /^(http|ftp):\/\//
      checksum %x[curl #{my_checksum}].split[0]
    else
      checksum my_checksum
    end

    if exec_action == :download_if_missing
      action :create_if_missing
    else
      action :nothing
    end
  end

  # check whether a new version is available
  http_request "osrm-#{new_resource.region}-download" do
    message ''
    url url

    if ::File.exists?(path)
      headers 'If-Modified-Since' => ::File.mtime(path).httpdate
    end

    notifies :create, "remote_file[#{path}]", :immediately
    action :head

    only_if { exec_action == :download }
  end
end

action :download do
  download(:download)
end

action :download_if_missing do
  download(:download_if_missing)
end
