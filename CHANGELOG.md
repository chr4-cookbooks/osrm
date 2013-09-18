osrm CHANGELOG
==============

This file is used to list changes made in each version of the osrm cookbook.

0.1.2
-----

- Attribute default for cleanup set to false [map_prepare]
- Add configuration settings for stxxl
- Attributes overriden in wrapper cookbooks are now evaluated correctly
- Use execute "rm -f" instead of file() { action :delete } for performance reasons
- Increase execute timeout to 1 day and add timeout option to the following providers

  * map
  * map_extract
  * map_prepare

  This is necessary for extract/prepare tasks that take longer than 1h.

0.1.1
-----

- Small bugfixes

0.1.0
-----
- [Chris Aumann] - Initial release of osrm
