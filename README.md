# puppet-globus

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/globus.svg)](https://forge.puppetlabs.com/treydock/globus)
[![CI Status](https://github.com/treydock/puppet-module-globus/workflows/CI/badge.svg?branch=master)](https://github.com/treydock/puppet-module-globus/actions?query=workflow%3ACI)

## Overview

This module manages Globus Connect Server.

### Supported Versions of Globus

Currently this module supports Globus 4.x and 5.4.

| Globus Version | Globus Puppet module versions |
| -------------- | ----------------------------- |
| 4.x            | 3.x                           |
| 4.x & 5.3      | 4.x                           |
| 4.x & 5.4      | 5.x-7.x                       |


### Upgrading to module version 5.x

Going from a version of this module prior to 5.0.0 to 5.x and using Globus v5 requires manual upgrade be performed.

See [Globus v5.4 Migration Guide](https://docs.globus.org/globus-connect-server/v5.4/migration-guide/) for details.

For sites using Globus v4 it's necessary to set `globus::version` to `4` in order to continue using Globus v4 as the default version was changed.

For sites using Globus v5.3 and upgrading this module 5.x, it's expected you are also upgrading to Globus v5.4. The parameters completely changed for Globus v5 support so see the examples below for changes needed and required parameters.

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

### Globus v4

Install and configure a Globus IO endpoint that uses OAuth.  This example assumes host cert/key will not be provided by Globus.

```puppet
class { 'globus':
  include_id_server => false,
  globus_user => 'myusername',
  globus_password => 'password',
  endpoint_name => 'myorg',
  endpoint_public => true,
  myproxy_server => 'myproxy.example.com:7512',
  oauth_server => 'myproxy.example.com',
  security_identity_method => 'OAuth',
  security_fetch_credentials_from_relay => false,
  security_certificate_file => '/etc/grid-security/hostcert.pem',
  security_key_file => '/etc/grid-security/hostkey.pem',
  gridftp_server => $::fqdn,
  gridftp_restrict_paths => ['RW~','N~/.*','RW/project'],
  # Example of extra settings
  extra_gridftp_settings => [
    'log_level ALL',
    'log_single /var/log/gridftp-auth.log',
    'log_transfer /var/log/gridftp-transfer.log',
  ],
}
```

This is an example of setting up a system that acts as both MyProxy and OAuth host.  This example assumes the host cert/key are not provided by Globus.

```puppet
  class { 'globus':
    include_io_server => false,
    include_id_server => true,
    include_oauth_server => true,
    globus_user => 'myusername',
    globus_password => 'password',
    endpoint_name => 'myorg',
    endpoint_public => true,
    myproxy_server => 'myproxy.example.com:7512',
    oauth_server => 'myproxy.example.com',
    security_identity_method => 'OAuth',
    security_fetch_credentials_from_relay => false,
    security_certificate_file => '/etc/grid-security/hostcert.pem',
    security_key_file => '/etc/grid-security/hostkey.pem',
  }
```

Below is an example of setting up the IO server to use CILogon.

```puppet
  class { 'globus':
    include_id_server => false,
    globus_user => 'myusername',
    globus_password => 'password',
    endpoint_name => 'myorg',
    endpoint_public => true,
    myproxy_server => 'myproxy.example.com:7512',
    oauth_server => 'myproxy.example.com',
    security_identity_method => 'CILogon',
    security_cilogon_identity_provider => 'My Org',
    security_fetch_credentials_from_relay => false,
    security_certificate_file => '/etc/grid-security/hostcert.pem',
    security_key_file => '/etc/grid-security/hostkey.pem',
    gridftp_server => $::fqdn,
    gridftp_restrict_paths => ['RW~','N~/.*','RW/project'],
    # Example of extra settings
    extra_gridftp_settings => [
      'log_level ALL',
      'log_single /var/log/gridftp-auth.log',
      'log_transfer /var/log/gridftp-transfer.log',
    ],
  }
```

Below is an example of what would be required to setup Globus GridFTP to also work with OSG GridFTP.  This example has not been verified since OSG 3.3.  OSG module referenced: https://github.com/treydock/puppet-osg

```puppet
  include ::osg
  include ::osg::gridftp
  class { '::globus':
    manage_service => false,
    include_id_server => false,
    remove_cilogon_cron => true,
    extra_gridftp_settings => [
      'log_level ALL'
      'log_single /var/log/gridftp-auth.log'
      'log_transfer /var/log/gridftp.log'
      '$LLGT_LOG_IDENT "gridftp-server-llgt"'
      '$LCMAPS_DB_FILE "/etc/lcmaps.db"'
      '$LCMAPS_POLICY_NAME "authorize_only"'
      '$LLGT_LIFT_PRIVILEGED_PROTECTION "1"'
      '$LCMAPS_DEBUG_LEVEL "2"'
      '$FTPNOSORT 1'
    ],
    first_gridftp_callback => '|globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout',
  }
  
  # Add globus repo before installing OSG GridFTP
  Yumrepo['Globus-Toolkit'] -> Package['osg-gridftp']
  # Apply OSG GridFTP before Globus
  Package['osg-gridftp'] -> Class['::globus::install']
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
* RedHat/Rocky 8
* Debian 9
* Debian 10
* Ubuntu 18.04
* Ubuntu 20.04
