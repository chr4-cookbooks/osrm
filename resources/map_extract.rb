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
attribute :map_dir,     kind_of: String
attribute :map,         kind_of: String
attribute :profile,     kind_of: String,  default: 'car'
attribute :profile_dir, kind_of: String
attribute :command,     kind_of: String
attribute :cwd,         kind_of: String
attribute :timeout,     kind_of: Integer, default: 3600 * 24 # 1 day
attribute :threads,     kind_of: String
attribute :memory,      kind_of: String
attribute :stxxl_size,  kind_of: Integer
attribute :stxxl_file,  kind_of: String,  default: '/var/tmp/stxxl'
attribute :user,        kind_of: String
