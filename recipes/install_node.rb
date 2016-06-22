#
# Cookbook Name:: osrm
# Recipe:: node
#
# Copyright 2016, Chris Aumann
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

# Use nodejs-4.x from the official repositories
# Currently, node-osrm only publishes modules for node 4.
# See: https://github.com/Project-OSRM/node-osrm/blob/master/.travis.yml#L27-L60
package 'apt-transport-https'

apt_repository 'node.js' do
  uri 'https://deb.nodesource.com/node_4.x'
  distribution node['lsb']['codename']
  components %w(main)
  key 'https://deb.nodesource.com/gpgkey/nodesource.gpg.key'
end

package 'nodejs'
