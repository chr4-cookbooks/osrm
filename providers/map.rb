#
# Cookbook Name:: osrm
# Provider:: map
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

def create(exec_action)
  osrm_map_download new_resource.region do
    map_dir  new_resource.map_dir  if new_resource.map_dir
    url      new_resource.map      if new_resource.map
    user     new_resource.user     if new_resource.user
    checksum new_resource.checksum if new_resource.checksum

    action :download_if_missing if exec_action == :create_if_missing

    # only download if map is on the internet
    only_if { new_resource.map =~ /^(http|ftp):\/\// }
  end

  osrm_map_extract new_resource.region do
    map_dir     new_resource.map_dir         if new_resource.map_dir
    map         new_resource.map             if new_resource.map
    profile     new_resource.profile         if new_resource.profile
    profile_dir new_resource.profile_dir     if new_resource.profile_dir
    command     new_resource.extract_command if new_resource.extract_command
    user        new_resource.user            if new_resource.user
    cwd         new_resource.cwd             if new_resource.cwd
    threads     new_resource.threads         if new_resource.threads
    memory      new_resource.memory          if new_resource.memory
    timeout     new_resource.timeout         if new_resource.timeout
    stxxl_file  new_resource.stxxl_file      if new_resource.stxxl_file
    stxxl_size  new_resource.stxxl_size      if new_resource.stxxl_size

    action :extract_if_missing if exec_action == :create_if_missing
  end

  osrm_map_prepare new_resource.region do
    map_dir     new_resource.map_dir         if new_resource.map_dir
    map         new_resource.map             if new_resource.map
    profile     new_resource.profile         if new_resource.profile
    profile_dir new_resource.profile_dir     if new_resource.profile_dir
    command     new_resource.prepare_command if new_resource.prepare_command
    user        new_resource.user            if new_resource.user
    cwd         new_resource.cwd             if new_resource.cwd
    threads     new_resource.threads         if new_resource.threads
    cleanup     new_resource.cleanup         if new_resource.cleanup
    timeout     new_resource.timeout         if new_resource.timeout

    action :prepare_if_missing if exec_action == :create_if_missing
  end
end

action :create do
  create(:create)
end

action :create_if_missing do
  create(:create_if_missing)
end
