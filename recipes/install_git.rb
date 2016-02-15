#
# Cookbook Name:: osrm
# Recipe:: install
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

package 'git-core'
package 'build-essential'
package 'cmake'
package 'libboost-all-dev'
package 'libbz2-dev'
package 'zlib1g-dev'
package 'libluajit-5.1-dev'
package 'libluabind-dev'
package 'libxml2-dev'
package 'libstxxl-dev'
package 'libosmpbf-dev'
package 'libprotoc-dev'
package 'libtbb-dev'


# define tasks
directory "#{node['osrm']['target']}/build" do
  action :nothing
end

execute 'cmake ..' do
  # TODO: user
  cwd    "#{node['osrm']['target']}/build"
  action :nothing
end

execute 'make' do
  # TODO: user
  cwd    "#{node['osrm']['target']}/build"
  action :nothing
end

git node['osrm']['target'] do
  repository  node['osrm']['repository']
  branch      node['osrm']['branch']

  # build
  notifies :create, "directory[#{node['osrm']['target']}/build]", :immediately
  notifies :run,    'execute[cmake ..]', :immediately
  notifies :run,    'execute[make]', :immediately

  # no continous deployment for a repository not under our control
  not_if { File.directory?("#{node['osrm']['target']}/build") }
end

# symlink binaries
%w{osrm-extract osrm-prepare osrm-routed osrm-datastore}.each do |binary|
  link "/usr/local/bin/#{binary}" do
    to "#{node['osrm']['target']}/build/#{binary}"
  end
end
