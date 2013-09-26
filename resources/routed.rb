#
# Cookbook Name:: osrm
# Resource:: routed
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

actions        :create, :delete
default_action :create

attribute :region,       kind_of: String,  name_attribute: true
attribute :profile,      kind_of: String,  default: 'car'
attribute :map_dir,      kind_of: String
attribute :map_base,     kind_of: String
attribute :config_dir,   kind_of: String
attribute :service_name, kind_of: String
attribute :user,         kind_of: String
attribute :home,         kind_of: String
attribute :daemon,       kind_of: String
attribute :threads,      kind_of: String
attribute :listen,       kind_of: String,  default: '127.0.0.1'
attribute :port,         kind_of: Integer, default: 5000
