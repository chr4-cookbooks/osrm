# OSRM cookbook

This cookbook can do the following things for you

* Install and configure the OSRM route daemon
* Download, extract, prepare map data and keep them up to date
  * (Uses the map data from [Geofabrik](http://download.geofabrik.de/))

To use the following recipes and providers, add the following to your metadata.rb

    depends 'osrm'


# Recipes

## default

Runs install_git

## install_git

Installs the latest [Project-OSRM](https://github.com/DennisOSRM/Project-OSRM) to ```node['osrm']['target']``` (default ```/opt/osrm```).


# Providers

## osrm_map

osrm_map is a shortcut that calls the other map providers in the following order

* osrm_map_download
* osrm_map_extract
* osrm_prepare

Example

    osrm_map 'europe'
      path
      user
      profile
      profile_dir
      command
      user
      cwd
      threads
      memory
      cleanup

      action :create
      action :create_if_missing
    end

    osrm_map_download 'europe' do
      action :download_if_missing
    end

    osrm_map_extract 'europe' do
      action :extract_if_missing
    end

    osrm_map_prepare 'europe' do
      action :prepare_if_missing
    end


## osrm_map_download

Downloads map data for the specified region.

    osrm_map_download 'planet'
    osrm_map_download 'europe'
    osrm_map_download 'north-america'
    osrm_map_download 'germany'
    osrm_map_download 'us-west'

For a full list of supported regions, take a look at [attributes/regions.rb](https://github.com/flinc-chef/osrm/blob/master/attributes/regions.rb). If necessary, it can be easily extended to support even more, feel free to file a pull request!

By default, the provider automatically re-downloads the file if it was changed on the server. You can prevent this behaviour when using the :download_if_missing action:

    osrm_map_download 'europe' do
      action :download_is_missing
    end

Furthermore, you can specify the following attributes:

    osrm_map_download 'us-west' do
      user 'my_osrm_user'
      path '/srv/my_map_data'
    end


## osrm_map_extract

Extracts downloaded map data, using osrm-extract.

Example:

    osrm_map_extract 'europe'

The following attributes are supported

    osrm_map_extract 'europe' do
      path        '/srv/my_map_data'  # use the same directory you used in osrm_map_download)
      profile     'car'               # profile to use (defaults to 'car')
      profile_dir '/srv/my_profiles'  # where to look for profiles (.lua files)
      command     'osrm-extract'      # binary to use
      user        'my_osrm_user'
      cwd         '/srv/my_osrm'      # set working directory for osrm-extract
      threads     5                   # how many threads to use (defaults to number of cpu cores)
      memory      4                   # how many GB of memory to use (defaults to system memory - 1GB)
    end


## osrm_map_prepare

Prepares extracted map data, using osrm-prepare.

Example:

    osrm_map_prepare 'europe'

The following attribtues are supported:

    osrm_map_prepare 'europe' do
      path        '/srv/my_map_data'  # use the same directory you used in osrm_map_download)
      profile     'car'               # profile to use (defaults to 'car')
      profile_dir '/srv/my_profiles'  # where to look for profiles (.lua files)
      command     'osrm-prepare'      # binary to use
      user        'my_osrm_user'
      cwd         '/srv/my_osrm'      # set working directory for osrm-prepare
      threads     5                   # how many threads to use (defaults to number of cpu cores)
      cleanup     false               # Do not cleanup .osrm and .osrm.restrictions after preparing
    end


## osrm_routed

Sets up and starts osrm-routed (using upstart) for the specified region

Example:

    osrm_routed 'europe'

The following attributes are supported:

    osrm_routed 'europe' do
      config_dir   '/etc/osrm-routed'
      service_name 'osrm-routed-%s'    # %s will be replaced with the selected region and profile

      profile      'car'               # profile for which to start the daemon

      user         'osrm-routed'       # user to run the daemon as (will be created if not existent)
      home         '/my/osrm-install'  # home directory of the osrm-routed user

      daemon       '/path/to/osrm-routed'

      threads      16                  # how many threads to use (defaults to number of cpu cores)

      port         5000                # TCP port to bind to
      listen       '127.0.0.1'         # TCP address to listen on
    end


# Attributes

You can set the following attributes if you need settings that differ form the defaults

## default

```ruby
node['osrm']['repository'] = 'git://github.com/DennisOSRM/Project-OSRM.git'
node['osrm']['branch'] = 'master' # use e.g. 'v0.3.5' for a stable version

node['osrm']['target'] = '/opt/osrm'
node['osrm']['map_path'] = '/opt/osrm-data'
```

## routed

```ruby
node['osrm']['routed']['user'] = 'osrm-routed'
node['osrm']['routed']['service_name'] = 'osrm-routed-%s'
node['osrm']['routed']['config_dir'] = '/etc/osrm-routed'
```

## regions

You can add custom regions like this

```ruby
node['osrm']['map_data']['your-region']['profiles'] = %w{car}
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
