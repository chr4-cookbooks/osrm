#
# Cookbook Name:: osrm
# Recipe:: default
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

include_recipe 'osrm::install_git'

#osrm_map_download 'north-america' do
#  action :download_if_missing
#end

#osrm_map_extract 'north-america'
#osrm_map_prepare 'north-america'

#osrm_routed 'north-america'

#service 'osrm-routed-north-america-car' do
#  action [ :start ]
#end
