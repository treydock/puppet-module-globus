# Class: globus: See README.md for documentation
class globus (
  Boolean $include_io_server                = true,
  Boolean $include_id_server                = true,
  Boolean $include_oauth_server             = false,
  $release_url                              = $globus::params::release_url,
  $repo_descr                               = $globus::params::repo_descr,
  $repo_baseurl                             = $globus::params::repo_baseurl,
  Boolean $remove_cilogon_cron              = false,
  Array $extra_gridftp_settings             = [],
  $first_gridftp_callback                   = undef,
  Boolean $manage_service                   = true,
  Boolean $run_setup_commands               = true,
  Boolean $manage_firewall                  = true,
  Boolean $manage_epel                      = true,

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
  Enum['MyProxy', 'OAuth', 'CILogon']
    $security_identity_method               = 'MyProxy',
  $security_authorization_method            = undef,
  $security_gridmap                         = undef,
  $security_cilogon_identity_provider       = undef,

  # GridFTP Config
  $gridftp_server                           = undef,
  $gridftp_server_port                      = '2811',
  $gridftp_server_behind_nat                = false,
  Array $gridftp_incoming_port_range        = ['50000', '51000'],
  $gridftp_outgoing_port_range              = undef, #'50000-51000',
  $gridftp_data_interface                   = undef,
  Array $gridftp_restrict_paths             = ['RW~', 'N~/.*'],
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
  Array $myproxy_firewall_sources           = ['174.129.226.69', '54.237.254.192/29'],

  # OAuth Config
  $oauth_server                             = undef,
  $oauth_server_behind_firewall             = false,
  $oauth_stylesheet                         = undef,
  $oauth_logo                               = undef,
) inherits globus::params {

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

  contain globus::install
  contain globus::config
  contain globus::service

  case $::osfamily {
    'RedHat': {
      if $manage_epel {
        include ::epel
        Class['epel'] -> Class['globus::repo::el']
      }
      contain globus::repo::el

      Class['globus::repo::el']
      -> Class['globus::install']
      -> Class['globus::config']
      -> Class['globus::service']
    }
    default: {
      # Do nothing
    }
  }

}
