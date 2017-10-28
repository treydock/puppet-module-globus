# puppet-globus

[![Puppet Forge](http://img.shields.io/puppetforge/v/treydock/globus.svg)](https://forge.puppetlabs.com/treydock/globus)
[![Build Status](https://travis-ci.org/treydock/puppet-module-globus.png)](https://travis-ci.org/treydock/puppet-module-globus)

## Overview

This module manages Globus Connect Server.

## Usage

### Class: globus

Install and configure a Globus IO endpoint that uses OAuth.  This example assumes host cert/key will not be provided by Globus.

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

This is an example of setting up a system that acts as both MyProxy and OAuth host.  This example assumes the host cert/key are not provided by Globus.

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

Below is an example of setting up the IO server to use CILogon.

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

Below is an example of what would be required to setup Globus GridFTP to also work with OSG GridFTP.  This example has not been verified since OSG 3.3.  OSG module referenced: https://github.com/treydock/puppet-osg

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

## Compatibility

Tested using

* CentOS 6
* RedHat 7

## Development

### Testing

Testing requires the following dependencies:

* rake
* bundler

Install gem dependencies

    bundle install

Run unit tests

    bundle exec rake test

If you have Vagrant >= 1.2.0 installed you can run system tests

    bundle exec rake beaker

## Further Information

*
