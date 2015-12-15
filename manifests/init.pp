# Class: globus: See README.md for documentation
class globus (
  $include_io_server                        = true,
  $include_id_server                        = true,
  $include_oauth_server                     = false,
  $release_url                              = $globus::params::release_url,
  $repo_descr                               = $globus::params::repo_descr,
  $repo_baseurl                             = $globus::params::repo_baseurl,
  $remove_cilogon_cron                      = false,
  $extra_gridftp_settings                   = [],
  $first_gridftp_callback                   = undef,
  $manage_service                           = true,
  $run_setup_commands                       = true,
  $manage_firewall                          = true,

  # Globus Config
  $globus_user                              = '%(GLOBUS_USER)s',
  $globus_password                          = '%(GLOBUS_PASSWORD)s',

  # Endpoint Config
  $endpoint_name                            = $::hostname,
  $endpoint_public                          = false,
  $endpoint_default_directory               = '/~/',

  # Security Config
  $security_fetch_credentials_from_relay    = true,
  $security_certificate_file                = '/var/lib/globus-connect-server/grid-security/hostcert.pem',
  $security_key_file                        = '/var/lib/globus-connect-server/grid-security/hostkey.pem',
  $security_trusted_certificate_directory   = '/var/lib/globus-connect-server/grid-security/certificates/',
  $security_identity_method                 = 'MyProxy',
  $security_authorization_method            = undef,
  $security_gridmap                         = undef,
  $security_cilogon_identity_provider       = undef,

  # GridFTP Config
  $gridftp_server                           = undef,
  $gridftp_server_port                      = '2811',
  $gridftp_server_behind_nat                = false,
  $gridftp_incoming_port_range              = ['50000', '51000'],
  $gridftp_outgoing_port_range              = undef, #'50000-51000',
  $gridftp_data_interface                   = undef,
  $gridftp_restrict_paths                   = ['RW~', 'N~/.*'],
  $gridftp_sharing                          = false,
  $gridftp_sharing_restrict_paths           = undef,
  $gridftp_sharing_state_dir                = '$HOME/.globus/sharing',
  $gridftp_sharing_users_allow              = undef,
  $gridftp_sharing_groups_allow             = undef,
  $gridftp_sharing_users_deny               = undef,
  $gridftp_sharing_groups_deny              = undef,

  # MyProxy Config
  $myproxy_server                           = undef,
  $myproxy_server_port                      = '7512',
  $myproxy_server_behind_nat                = false,
  $myproxy_ca_directory                     = '/var/lib/globus-connect-server/myproxy-ca',
  $myproxy_config_file                      = '/var/lib/globus-connect-server/myproxy-server.conf',

  # OAuth Config
  $oauth_server                             = undef,
  $oauth_server_behind_firewall             = false,
  $oauth_stylesheet                         = undef,
  $oauth_logo                               = undef,
) inherits globus::params {

  validate_bool(
    $include_io_server,
    $include_id_server,
    $include_oauth_server,
    $remove_cilogon_cron,
    $manage_service,
    $run_setup_commands,
    $manage_firewall
  )

  validate_array(
    $extra_gridftp_settings,
    $gridftp_incoming_port_range,
    $gridftp_restrict_paths
  )

  case $security_identity_method {
    'MyProxy': {
      # Do nothing
    }
    'OAuth': {
      # Do nothing
    }
    'CILogon': {
      validate_string($security_cilogon_identity_provider)
    }
    default: {
      fail("Unsupported identity_method: ${security_identity_method}, module ${module_name} only supports MyProxy, OAuth and CILogon")
    }
  }

  if $include_io_server {
    $_gridftp_server    = pick($gridftp_server, "${::fqdn}:${gridftp_server_port}")
    $_io_setup_command  = 'globus-connect-server-io-setup'
  } else {
    $_gridftp_server    = $gridftp_server
    $_io_setup_command  = undef
  }

  if $include_id_server {
    $_myproxy_server    = pick($myproxy_server, "${::fqdn}:${myproxy_server_port}")
    $_id_setup_command  = 'globus-connect-server-id-setup'
  } else {
    $_myproxy_server    = $myproxy_server
    $_id_setup_command  = undef
  }

  if $include_oauth_server {
    $_oauth_server        = pick($oauth_server, $::fqdn)
    $_oauth_setup_command = 'globus-connect-server-web-setup'
  } else {
    $_oauth_server        = $oauth_server
    $_oauth_setup_command = undef
  }

  $_setup_commands  = delete_undef_values([$_io_setup_command, $_id_setup_command, $_oauth_setup_command])
  $_setup_command   = join($_setup_commands, ' && ')

  anchor { 'globus::start': }
  anchor { 'globus::end': }

  include globus::install
  include globus::config
  include globus::service

  case $::osfamily {
    'RedHat': {
      include ::epel
      include globus::repo::el

      Anchor['globus::start']->
      Class['epel']->
      Class['globus::repo::el']->
      Class['globus::install']->
      Class['globus::config']->
      Class['globus::service']->
      Anchor['globus::end']
    }
    default: {
      # Do nothing
    }
  }

}
