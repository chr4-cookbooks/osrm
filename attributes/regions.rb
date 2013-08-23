#
# Cookbook Name:: osrm
# Attributes:: regions
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

# planet
default['osrm']['map_data']['planet']['profiles'] = %w{car}
default['osrm']['map_data']['planet']['url'] = 'http://planet.openstreetmap.org/pbf/planet-latest.osm.pbf'
default['osrm']['map_data']['planet']['checksum'] = "#{node['osrm']['map_data']['planet']['url']}.md5"

# continents
%w{africa antarctica asia australia-oceania central-america europe north-america south-america}.each do |region|
  default['osrm']['map_data'][region]['profiles'] = %w{car}
  default['osrm']['map_data'][region]['url'] = "http://download.geofabrik.de/#{region}-latest.osm.pbf"
  default['osrm']['map_data'][region]['checksum'] = "#{node['osrm']['map_data'][region]['url']}.md5"
end

# europe
%w{
  albania alps andorra austria azores belarus belgium bosnia-herzegovina british-isles
  bulgaria croatia cyprus czech-republic denmark estonia faroe-islands finland france germany
  great-britain greece hungary iceland ireland-and-northern-ireland isle-of-man italy kosovo latvia
  liechtenstein lithuania luxembourg macedonia malta moldova monaco montenegro netherlands norway
  poland portugal romania russia-european-part serbia slovakia slovenia spain sweden switzerland
  turkey ukraine
}.each do |region|
  default['osrm']['map_data'][region]['profiles'] = %w{car}
  default['osrm']['map_data'][region]['url'] = "http://download.geofabrik.de/europe/#{region}-latest.osm.pbf"
  default['osrm']['map_data'][region]['checksum'] = "#{node['osrm']['map_data'][region]['url']}.md5"
end

# north-america
%w{
  canada greenland us-midwest us-northeast us-pacific us-south us-west alabama alaska arizona
  arkansas california colorado connecticut delaware district-of-columbia florida georgia hawaii
  idaho illinois indiana iowa kansas kentucky louisiana maine maryland massachusetts michigan
  minnesota mississippi missouri montana nebraska nevada new-hampshire new-jersey new-mexico
  new-york north-carolina north-dakota ohio oklahoma oregon pennsylvania rhode-island south-carolina
  south-dakota tennessee texas utah vermont virginia washington west-virginia wisconsin wyoming
}.each do |region|
  default['osrm']['map_data'][region]['profiles'] = %w{car}
  default['osrm']['map_data'][region]['url'] = "http://download.geofabrik.de/north-america/#{region}-latest.osm.pbf"
  default['osrm']['map_data'][region]['checksum'] = "#{node['osrm']['map_data'][region]['url']}.md5"
end

# TODO: other continents
