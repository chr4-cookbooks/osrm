name             'osrm'
maintainer       'Chris Aumann'
maintainer_email 'me@chr4.org'
license          'GNU Public License 3.0'
description      'Installs/Configures osrm'
long_description IO.read(File.join(File.dirname(__FILE__), 'README.md'))
version          '5.2.1'
source_url       'https://github.com/chr4-cookbooks/osrm' if respond_to?(:source_url)
issues_url       'https://github.com/chr4-cookbooks/osrm/issues' if respond_to?(:issues_url)
supports         'ubuntu'
depends          'sysctl'
depends          'apt'
