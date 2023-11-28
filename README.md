# puppet-globus

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/globus.svg)](https://forge.puppetlabs.com/treydock/globus)
[![CI Status](https://github.com/treydock/puppet-module-globus/workflows/CI/badge.svg?branch=master)](https://github.com/treydock/puppet-module-globus/actions?query=workflow%3ACI)

## Overview

This module manages Globus Connect Server.

### Supported Versions of Globus

Currently this module supports Globus 5.4.

| Globus Version | Globus Puppet module versions |
| -------------- | ----------------------------- |
| 4.x            | 3.x                           |
| 4.x & 5.3      | 4.x                           |
| 4.x & 5.4      | 5.x-9.x                       |
| 5.4            | 10.x                          |

## Usage

### Globus v5.4

The steps performed by this module are to install Globus and run the `globus endpoint setup` and `globus node setup` commands.

The following is the minimum parameters that must be passed to setup Globus v5.4.

```puppet
class { 'globus':
  display_name  => 'REPLACE My Site Globus',
  client_id     => 'REPLACE-client-id-from-globus',
  client_secret => 'REPLACE-client-id-from-globus',
  owner         => 'REPLACE-user@example.com',
  organization  => 'REPLACE-My Site',
}
```

### Globus CLI

To install the Globus CLI to `/opt/globus-cli` and create symlink for executable at `/usr/bin/globus`:

```puppet
include globus::cli
```

### Globus Timer

To install the Globus Timer CLI to `/opt/globus-timer` and create symlink for executable at `/usr/bin/globus-timer`:

```puppet
include globus::timer
```

### Globus SDK

To install the Globus SDK to `/opt/globus-sdk`:

```puppet
include globus::sdk
```

### Facts

The `globus_info` fact exposes the information stored in `/var/lib/globus-connect-server/info.json`.  Example:

```
# facter -p globus_info
{
  endpoint_id => "1c6b6e6a-3791-4213-b3e6-00000001",
  domain_name => "00000001.8443.data.globus.org",
  manager_version => "5.4.11",
  DATA_TYPE => "info#1.0.0",
  client_id => "1c6b6e6a-3791-4213-b3e6-00000001",
  api_version => "1.3.0"
}

```

## Reference

[http://treydock.github.io/puppet-module-globus/](http://treydock.github.io/puppet-module-globus/)

## Compatibility

Tested using

* RedHat/CentOS 7
* RedHat/Rocky 8 & 9
* Debian 11
* Ubuntu 20.04 & 22.04

