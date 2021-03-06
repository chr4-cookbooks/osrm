# OSRM cookbook

This cookbook can do the following things for you

* Install and configure the OSRM route daemon
* Download, extract, contract map data and keep them up to date
  * (Uses the map data from [Geofabrik](http://download.geofabrik.de/))

To use the following recipes and providers, add the following to your metadata.rb

```ruby
depends 'osrm'
```

# Recipes

## default

Runs install_git

## install_git

Clone and install the latest HEAD from [Project-OSRM](https://github.com/Project-OSRM/osrm-backend) to ```node['osrm']['target']``` (default ```/opt/osrm```).


# Providers

## osrm_map

osrm_map is a shortcut that calls the other map providers in the following order

* osrm_map_download
* osrm_map_extract
* osrm_contract

This example downloads, extracts and contracts the osrm map for Germany:

```ruby
osrm_map 'germany'
```

The following additional attributes are allowed:

```ruby
osrm_map 'europe'
  map_dir         '/srv/my_map_data'     # Where to put the maps (defaults to '/opt/osrm-data')

  # Path to the map (osm.pbf or osm.bz2) to use.
  # This is filled in automatically if the file is downloaded.
  # Only use it in case you are using a custom map.
  map             '/path/to/map.osm.bpf'

  profile         'car'                  # Profile to use (defaults to 'car')
  profile_dir     '/srv/my_profiles'     # Where to look for profiles (.lua files)
  extract_command 'osrm-extract'         # Path to osrm-extract binary
  contract_command 'osrm-contract'         # Path to osrm-contract binary
  user            'my_osrm_user'         # User to run commands as
  cwd             '/srv/my_osrm'         # Set working directory for osrm-extract
  threads         5                      # How many threads to use (defaults to number of cpu cores)
  cleanup         false                  # Do not cleanup .osrm and .osrm.restrictions after preparing
  timeout         3600                   # Timeout in seconds for osrm-extract/osrm-contract. Defaults to 24h
  stxxl_size      150000                 # Size (in MB) of stxxl temporary file. Dynamically allocated by default
  stxxl_file      '/tmp/stxxl'           # Location of stxxl temporary file. Defaults to '/var/tmp/stxxl'

  # The files checksum can also be checked (defaults to true)
  # When set to true, it will use the default checksum set in the attributes (if existent)
  # When set to false, it doesn't check the checksum
  # When set to an ftp:// or http:// URL, retrieve the file and use the checksum in its content
  # When set to a string, use it as the checksum
  checksum        'http://url.to/checksum.md5'
end

```

## osrm_map_download

Downloads map data for the specified region.

```ruby
osrm_map_download 'planet'
osrm_map_download 'europe'
osrm_map_download 'north-america'
osrm_map_download 'germany'
osrm_map_download 'us-west'
```

For a full list of supported regions, take a look at [attributes/regions.rb](https://github.com/chr4-cookbooks/osrm/blob/master/attributes/regions.rb). If necessary, it can be easily extended to support even more, feel free to file a pull request!

By default, the provider automatically re-downloads the file if it was changed on the server. You can prevent this behaviour when using the :download_if_missing action:

```ruby
osrm_map_download 'europe' do
  action :download_is_missing
end
```

Furthermore, you can specify the following attributes:

```ruby
osrm_map_download 'us-west' do
  user     'my_osrm_user'
  map_dir  '/srv/my_map_data' # Where to put the downloaded files (defaults to '/opt/osrm-data')

  # Manually specify url to download map from.
  # Defaults to the URL in the attributes (available for most regions)
  url      'http://my.geoserver.com/map.osm.bpf'

  # The files checksum can also be checked (defaults to false)
  # When set to true, it will use the default checksum set in the attributes
  # When set to false, it doesn't check the checksum
  # When set to an ftp:// or http:// URL, use its contents as a checksum
  # When set to a string, use it as the checksum
  checksum 'http://url.to/checksum.md5'
end
```

## osrm_map_extract

Extracts downloaded map data, using osrm-extract.

Example:

```ruby
osrm_map_extract 'europe'
```

The following attributes are supported:

```ruby
osrm_map_extract 'europe' do
  map_dir     '/srv/my_map_data'  # Use the same directory you used in osrm_map_download

  # Path to the map (osm.pbf or osm.bz2) to use.
  # This is set automatically (via attributes),
  # if you use a map downloaded by osrm_map_download.
  # Only use it in case you are using a custom map.
  map        '/path/to/map.osm.bpf'

  profile     'car'               # Profile to use (defaults to 'car')
  profile_dir '/srv/my_profiles'  # Where to look for profiles (.lua files)
  command     'osrm-extract'      # Binary to use
  user        'my_osrm_user'
  cwd         '/srv/my_osrm'      # Set working directory for osrm-extract
  threads     5                   # How many threads to use (defaults to number of cpu cores)
  timeout     3600                # Timeout in seconds for osrm-extract. Defaults to 24h
  stxxl_size  150000              # Size (in MB) of stxxl temporary file. Dynamically allocated by default
  stxxl_file  '/tmp/stxxl'        # Location of stxxl temporary file. Defaults to '/var/tmp/stxxl'
end
```

## osrm_map_contract

contracts extracted map data, using osrm-contract.

Example:

```ruby
osrm_map_contract 'europe'
```

The following attribtues are supported:

```ruby
osrm_map_contract 'europe' do
  map_dir     '/srv/my_map_data'  # Use the same directory you used in osrm_map_download

  # Path to the map (osm.pbf or osm.bz2) to use.
  # This is set automatically (via attributes),
  # if you use a map downloaded by osrm_map_download.
  # Only use it in case you are using a custom map.
  map        '/path/to/map.osm.bpf'

  profile     'car'               # Profile to use (defaults to 'car')
  command     'osrm-contract'      # Binary to use
  user        'my_osrm_user'
  cwd         '/srv/my_osrm'      # Set working directory for osrm-contract
  threads     5                   # How many threads to use (defaults to number of cpu cores)
  cleanup     false               # Do not cleanup .osrm and .osrm.restrictions after preparing
  timeout     3600                # Timeout in seconds for osrm-extract. Defaults to 24h
end
```

## osrm_node

Sets up and starts the [node-osrm](https://github.com/Project-OSRM/node-osrm) service.

```ruby
osrm_node 'europe' do
  profile  'car'               # Profile for which to start the daemon
  user     'osrm-node'         # User to run the daemon as
  port     5000                # TCP port to bind to
  listen   '127.0.0.1'         # TCP address to listen on
  map_base '/path/to/map_base' # Base path of the (contracted) map
                               # e.g. '/opt/osrm-data/europe/car/europe-lastest'
                               # (skip the file extention, like .edges or .osm.bpf)
  shared_memory false          # Use a shared-memory segment (created by osrm-datastore, see next provider)
end
```

## osrm_routed

Sets up and starts osrm-routed (using upstart) for the specified region.
NOTE: `osrm_routed` is not recommended for production usage. Use the `osrm_node` provider instead to deploy [node-osrm](https://github.com/Project-OSRM/node-osrm).

Example:

```ruby
osrm_routed 'europe'
```

The following attributes are supported:

```ruby
osrm_routed 'europe' do
  service_name 'osrm-routed-%s'    # %s will be replaced with the selected region and profile
  profile      'car'               # Profile for which to start the daemon
  user         'osrm-routed'       # User to run the daemon as

  daemon       '/path/to/osrm-routed'

  map_dir      '/srv/my_map_data'  # Use the same directory you used in osrm_map_download)
  map_base     '/path/to/map_base' # Base path of the (contracted) map
                                   # e.g. '/opt/osrm-data/europe/car/europe-lastest'
                                   # (skip the file extention, like .edges or .osm.bpf)

  threads      16                  # How many threads to use (defaults to number of cpu cores)

  port         5000                # TCP port to bind to
  listen       '127.0.0.1'         # TCP address to listen on

  shared_memory false              # Use a shared-memory segment (created by osrm-datastore, see next provider)
end
```

## osrm_datastore

Loads a specified map into memory

Example:

```ruby
osrm_datastore 'europe'
```

The following attributes are supported:

```ruby
osrm_datastore 'europe' do
  profile      'car'               # Profile for which to start the daemon
  shmmax       5_000_000_000       # Memory limit in bytes. Defaults to a value that should be enough for world
  user         'osrm-routed'       # User to run the daemon as (will be created if not existent)

  command      '/path/to/osrm-datastore'

  map_dir      '/srv/my_map_data'  # Use the same directory you used in osrm_map_download)
  map_base     '/path/to/map_base' # Base path of the (contractd) map
                                   # e.g. '/opt/osrm-data/europe/car/europe-lastest'
                                   # (skip the file extention, like .edges or .osm.bpf)
end
```


# Attributes

You can set the following attributes if you need settings that differ form the defaults

## default

```ruby
node['osrm']['repository'] = 'https://github.com/Project-OSRM/osrm-backend'
node['osrm']['branch'] = 'master' # use e.g. 'v0.3.5' for a stable version

node['osrm']['target'] = '/opt/osrm'
node['osrm']['map_dir'] = '/opt/osrm-data'

node['osrm']['threads'] = node['cpu']['total']

```

## routed

```ruby
node['osrm']['routed']['user'] = 'osrm-routed'
node['osrm']['routed']['service_name'] = 'osrm-routed-%s'
```

## regions

You can add custom regions like this

```ruby
node['osrm']['map_data']['your-region']['profiles'] = %w(car)
node['osrm']['map_data']['your-region']['url'] = "http://download.geofabrik.de/your-region-latest.osm.pbf"
node['osrm']['map_data']['your-region']['checksum'] = "#{node['osrm']['map_data']['your-region']['url']}.md5"
```

# Contributing

Pull requests are very welcome!

1. Fork the repository on Github
2. Create a named feature branch (like `add_component_x`)
3. Write you change
4. Write tests for your change (if applicable)
5. Run the tests, ensuring they all pass
6. Submit a Pull Request using Github
