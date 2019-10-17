# @summary Manage globus configs
# @api private
class globus::config {

  if $globus::run_setup_commands {
    $_globus_connect_config_notify = Exec['globus-connect-server-setup']
    $_resources_require_setup      = Exec['globus-connect-server-setup']

    exec { 'globus-connect-server-setup':
      path        => '/usr/bin:/bin:/usr/sbin:/sbin',
      command     => $globus::_setup_command,
      refreshonly => true,
    }
  } else {
    $_globus_connect_config_notify  = undef
    $_resources_require_setup       = undef
  }

  file { '/etc/globus-connect-server.conf':
    ensure => 'file',
    owner  => 'root',
    group  => 'root',
    mode   => '0600',
  }

  resources { 'globus_connect_config': purge => true }

  Globus_connect_config {
    notify => $_globus_connect_config_notify,
  }

  Globus_connect_config <| tag == "v${globus::version}" |>

  # Globus Configs
  @globus_connect_config { 'Globus/User': value => $globus::globus_user, tag => 'v4' }
  @globus_connect_config { 'Globus/Password': value => $globus::globus_password, secret => true, tag => 'v4' }
  @globus_connect_config { 'Globus/ClientId': value => $globus::globus_client_id, tag => 'v5' }
  @globus_connect_config { 'Globus/ClientSecret': value => $globus::globus_client_secret, secret => true, tag => 'v5' }

  # Endpoint Configs
  @globus_connect_config { 'Endpoint/Name': value => $globus::endpoint_name, tag => ['v4','v5'] }
  @globus_connect_config { 'Endpoint/ServerName': value => $globus::endpoint_server_name, tag => 'v5' }
  @globus_connect_config { 'Endpoint/Public': value => $globus::endpoint_public, tag => 'v4' }
  @globus_connect_config { 'Endpoint/DefaultDirectory': value => $globus::endpoint_default_directory, tag => 'v4' }

  # LetsEncrypt Configs (v5)
  @globus_connect_config { 'LetsEncrypt/Email': value => $globus::letsencrypt_email, tag => 'v5' }
  @globus_connect_config { 'LetsEncrypt/AgreeToS': value => $globus::letsencrypt_agreetos, tag => 'v5' }

  # Security Configs
  @globus_connect_config { 'Security/FetchCredentialFromRelay': value => $globus::security_fetch_credentials_from_relay, tag => 'v4' }
  @globus_connect_config { 'Security/CertificateFile': value => $globus::security_certificate_file, tag => 'v4' }
  @globus_connect_config { 'Security/KeyFile': value => $globus::security_key_file, tag => 'v4' }
  @globus_connect_config { 'Security/TrustedCertificateDirectory': value => $globus::security_trusted_certificate_directory, tag => 'v4' }
  @globus_connect_config { 'Security/IdentityMethod': value => $globus::security_identity_method, tag => 'v4' }
  if $globus::security_authorization_method {
    @globus_connect_config { 'Security/AuthorizationMethod': value => $globus::security_authorization_method, tag => 'v4' }
  }
  if $globus::security_gridmap {
    @globus_connect_config { 'Security/Gridmap': value => $globus::security_gridmap, tag => 'v4' }
  }
  if $globus::security_cilogon_identity_provider {
    @globus_connect_config { 'Security/CILogonIdentityProvider': value => $globus::security_cilogon_identity_provider, tag => 'v4' }
  }

  # GridFTP Configs
  if $globus::version == '5' or ($globus::include_io_server and $globus::_gridftp_server) {
    @globus_connect_config { 'GridFTP/Server': value => $globus::_gridftp_server, tag => 'v4' }
    @globus_connect_config { 'GridFTP/ServerBehindNAT': value => $globus::gridftp_server_behind_nat, tag => 'v4' }
    @globus_connect_config { 'GridFTP/IncomingPortRange': value => join($globus::gridftp_incoming_port_range, ','), tag => ['v4','v5'] }
    if $globus::gridftp_outgoing_port_range {
      @globus_connect_config { 'GridFTP/OutgoingPortRange': value => join($globus::gridftp_outgoing_port_range, ','), tag => ['v4','v5'] }
    }
    if $globus::gridftp_data_interface {
      @globus_connect_config { 'GridFTP/DataInterface': value => $globus::gridftp_data_interface, tag => ['v4','v5'] }
    }
    @globus_connect_config { 'GridFTP/RestrictPaths': value => join($globus::gridftp_restrict_paths, ','), tag => 'v4' }
    @globus_connect_config { 'GridFTP/Sharing': value => $globus::gridftp_sharing, tag => 'v4' }
    @globus_connect_config { 'GridFTP/RequireEncryption': value => $globus::gridftp_require_encryption, tag => 'v5' }
    if $globus::gridftp_sharing_restrict_paths {
      @globus_connect_config { 'GridFTP/SharingRestrictPaths': value => join($globus::gridftp_sharing_restrict_paths, ','), tag => 'v4' }
    }
    @globus_connect_config { 'GridFTP/SharingStateDir': value => $globus::gridftp_sharing_state_dir, tag => 'v4' }
    if $globus::gridftp_sharing_users_allow {
      @globus_connect_config { 'GridFTP/SharingUsersAllow': value => join($globus::gridftp_sharing_users_allow, ','), tag => 'v4' }
    }
    if $globus::gridftp_sharing_groups_allow {
      @globus_connect_config { 'GridFTP/SharingGroupsAllow': value => join($globus::gridftp_sharing_groups_allow, ','), tag => 'v4' }
    }
    if $globus::gridftp_sharing_users_deny {
      @globus_connect_config { 'GridFTP/SharingUsersDeny': value => join($globus::gridftp_sharing_users_deny, ','), tag => 'v4' }
    }
    if $globus::gridftp_sharing_groups_deny {
      @globus_connect_config { 'GridFTP/SharingGroupsDeny': value => join($globus::gridftp_sharing_groups_deny, ','), tag => 'v4' }
    }
  }

  # MyProxy Configs
  if $globus::_myproxy_server {
    @globus_connect_config { 'MyProxy/Server': value => $globus::_myproxy_server, tag => 'v4' }
    @globus_connect_config { 'MyProxy/ServerBehindNAT': value => $globus::myproxy_server_behind_nat, tag => 'v4' }
    @globus_connect_config { 'MyProxy/CADirectory': value => $globus::myproxy_ca_directory, tag => 'v4' }
    @globus_connect_config { 'MyProxy/ConfigFile': value => $globus::myproxy_config_file, tag => 'v4' }
    if $globus::myproxy_ca_subject_dn {
      @globus_connect_config { 'MyProxy/CaSubjectDN': value => $globus::myproxy_ca_subject_dn, tag => 'v4' }
    }
  }

  # OAuth Configs
  if $globus::_oauth_server {
    @globus_connect_config { 'OAuth/Server': value => $globus::_oauth_server, tag => 'v4' }
    @globus_connect_config { 'OAuth/ServerBehindNAT': value => $globus::oauth_server_behind_firewall, tag => 'v4' }
    if $globus::oauth_stylesheet {
      @globus_connect_config { 'OAuth/Stylesheet': value => $globus::oauth_stylesheet, tag => 'v4' }
    }
    if $globus::oauth_logo {
      @globus_connect_config { 'OAuth/Logo': value => $globus::oauth_logo, tag => 'v4' }
    }
  }

  if $globus::remove_cilogon_cron {
    file { '/etc/cron.hourly/globus-connect-server-cilogon-basic-crl':
      ensure => 'absent'
    }
    file { '/etc/cron.hourly/globus-connect-server-cilogon-silver-crl':
      ensure => 'absent'
    }
  }

  if ! empty($globus::extra_gridftp_settings) {
    file { '/etc/gridftp.d/z-extra-settings':
      ensure  => 'file',
      content => template('globus/gridftp-extra-settings.erb'),
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      notify  => $globus::notify_service,
    }
  }

  if $globus::version == '4' and $globus::first_gridftp_callback {
    $_first_gridftp_callback_match = regsubst($globus::first_gridftp_callback, '\|', '\\|', 'G')
    exec { 'add-gridftp-callback':
      path    => '/usr/bin:/bin:/usr/sbin:/sbin',
      command => "sed -i '1s/^/${globus::first_gridftp_callback}\\n/' /var/lib/globus-connect-server/gsi-authz.conf",
      unless  => "head -n 1 /var/lib/globus-connect-server/gsi-authz.conf | egrep -q '^${_first_gridftp_callback_match}$'",
      onlyif  => 'test -f /var/lib/globus-connect-server/gsi-authz.conf',
      require => $_resources_require_setup,
      notify  => Service['globus-gridftp-server'],
    }
  }

  if $globus::manage_firewall {
    if String($globus::version) == '4' {
      firewall { '500 allow GridFTP control channel':
        action => 'accept',
        dport  => $globus::gridftp_server_port,
        proto  => 'tcp',
      }
    }

    if String($globus::version) == '5' {
      firewall { '500 allow HTTPS':
        action => 'accept',
        dport  => '443',
        proto  => 'tcp',
      }
    }

    $_gridftp_incoming_ports = join($globus::gridftp_incoming_port_range, '-')
    firewall { '500 allow GridFTP data channels':
      action => 'accept',
      dport  => $_gridftp_incoming_ports,
      proto  => 'tcp',
    }

    if String($globus::version) == '4' and $globus::include_id_server {
      $globus::myproxy_firewall_sources.each |$source| {
        firewall { "500 allow MyProxy from ${source}":
          action   => 'accept',
          dport    => $globus::myproxy_server_port,
          proto    => 'tcp',
          source   => $source,
          provider => 'iptables',
        }
      }
    }

    if String($globus::version) == '4' and $globus::include_oauth_server {
      firewall { '500 allow OAuth HTTPS':
        action => 'accept',
        dport  => '443',
        proto  => 'tcp',
      }
    }
  }

}
