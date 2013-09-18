#
# Cookbook Name:: osrm
# Resource:: map_extract
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

actions        :extract, :extract_if_missing
default_action :extract

attribute :region,      kind_of: String,  name_attribute: true
attribute :path,        kind_of: String,  default: node['osrm']['map_path']
attribute :profile,     kind_of: String,  default: 'car'
attribute :profile_dir, kind_of: String
attribute :command,     kind_of: String
attribute :cwd,         kind_of: String
attribute :timeout,     kind_of: Integer, default: 3600 * 24 # 1 day
attribute :threads,     kind_of: String,  default: node['cpu']['total']
attribute :memory,      kind_of: String,  default: node['memory']['total'].to_i / 1024 / 1024 - 1 # in GB, leave 1gb for system
attribute :stxxl_size,  kind_of: Integer, default: 10240
attribute :stxxl_file,  kind_of: String
attribute :user,        kind_of: String
