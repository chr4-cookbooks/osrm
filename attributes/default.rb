#
# Cookbook Name:: osrm
# Attributes:: default
#
# Copyright 2013, Chris Aumann
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

default['osrm']['repository'] = 'git://github.com/Project-OSRM/osrm-backend.git'
default['osrm']['branch'] = 'master'

default['osrm']['target'] = '/opt/osrm'
default['osrm']['map_dir'] = '/opt/osrm-data'

default['osrm']['threads'] = node['cpu']['total']
