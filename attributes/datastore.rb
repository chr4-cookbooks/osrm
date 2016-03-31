#
# Cookbook Name:: osrm
# Attributes:: datastore
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

default['osrm']['datastore']['user'] = 'osrm-routed' # Default to routed user
default['osrm']['datastore']['service_name'] = 'osrm-datastore-%s'

# This should be enought for world maps
default['osrm']['shmmax'] = 18_446_744_073_709_551_615
