#
# Cookbook Name:: osrm
# Resource:: map_download
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

actions        :download, :download_if_missing
default_action :download

attribute :region,   kind_of: String, name_attribute: true
attribute :map_dir,  kind_of: String
attribute :url,      kind_of: String
attribute :checksum, kind_of: [ TrueClass, FalseClass, String ], default: false
attribute :user,     kind_of: String
