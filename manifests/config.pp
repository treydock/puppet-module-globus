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

  if String($globus::version) == '4' {
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

    # Globus Configs
    globus_connect_config { 'Globus/User': value => $globus::globus_user }
    globus_connect_config { 'Globus/Password': value => $globus::globus_password, secret => true }

    # Endpoint Configs
    globus_connect_config { 'Endpoint/Name': value => $globus::endpoint_name }
    globus_connect_config { 'Endpoint/Public': value => $globus::endpoint_public }
    globus_connect_config { 'Endpoint/DefaultDirectory': value => $globus::endpoint_default_directory }

    # Security Configs
    globus_connect_config { 'Security/FetchCredentialFromRelay': value => $globus::security_fetch_credentials_from_relay }
    globus_connect_config { 'Security/CertificateFile': value => $globus::security_certificate_file }
    globus_connect_config { 'Security/KeyFile': value => $globus::security_key_file }
    globus_connect_config { 'Security/TrustedCertificateDirectory': value => $globus::security_trusted_certificate_directory }
    globus_connect_config { 'Security/IdentityMethod': value => $globus::security_identity_method }
    if $globus::security_authorization_method {
      globus_connect_config { 'Security/AuthorizationMethod': value => $globus::security_authorization_method }
    }
    if $globus::security_gridmap {
      globus_connect_config { 'Security/Gridmap': value => $globus::security_gridmap }
    }
    if $globus::security_cilogon_identity_provider {
      globus_connect_config { 'Security/CILogonIdentityProvider': value => $globus::security_cilogon_identity_provider }
    }

    # GridFTP Configs
    if $globus::include_io_server and $globus::_gridftp_server {
      globus_connect_config { 'GridFTP/Server': value => $globus::_gridftp_server }
      globus_connect_config { 'GridFTP/ServerBehindNAT': value => $globus::gridftp_server_behind_nat }
      globus_connect_config { 'GridFTP/IncomingPortRange': value => join($globus::gridftp_incoming_port_range, ',') }
      if $globus::gridftp_outgoing_port_range {
        globus_connect_config { 'GridFTP/OutgoingPortRange': value => join($globus::gridftp_outgoing_port_range, ',') }
      }
      if $globus::gridftp_data_interface {
        globus_connect_config { 'GridFTP/DataInterface': value => $globus::gridftp_data_interface }
      }
      globus_connect_config { 'GridFTP/RestrictPaths': value => join($globus::gridftp_restrict_paths, ',') }
      globus_connect_config { 'GridFTP/Sharing': value => $globus::gridftp_sharing }
      if $globus::gridftp_sharing_restrict_paths {
        globus_connect_config { 'GridFTP/SharingRestrictPaths': value => join($globus::gridftp_sharing_restrict_paths, ',') }
      }
      globus_connect_config { 'GridFTP/SharingStateDir': value => $globus::gridftp_sharing_state_dir }
      if $globus::gridftp_sharing_users_allow {
        globus_connect_config { 'GridFTP/SharingUsersAllow': value => join($globus::gridftp_sharing_users_allow, ',') }
      }
      if $globus::gridftp_sharing_groups_allow {
        globus_connect_config { 'GridFTP/SharingGroupsAllow': value => join($globus::gridftp_sharing_groups_allow, ',') }
      }
      if $globus::gridftp_sharing_users_deny {
        globus_connect_config { 'GridFTP/SharingUsersDeny': value => join($globus::gridftp_sharing_users_deny, ',') }
      }
      if $globus::gridftp_sharing_groups_deny {
        globus_connect_config { 'GridFTP/SharingGroupsDeny': value => join($globus::gridftp_sharing_groups_deny, ',') }
      }
    }

    # MyProxy Configs
    if $globus::_myproxy_server {
      globus_connect_config { 'MyProxy/Server': value => $globus::_myproxy_server }
      globus_connect_config { 'MyProxy/ServerBehindNAT': value => $globus::myproxy_server_behind_nat }
      globus_connect_config { 'MyProxy/CADirectory': value => $globus::myproxy_ca_directory }
      globus_connect_config { 'MyProxy/ConfigFile': value => $globus::myproxy_config_file }
      if $globus::myproxy_ca_subject_dn {
        globus_connect_config { 'MyProxy/CaSubjectDN': value => $globus::myproxy_ca_subject_dn }
      }
    }

    # OAuth Configs
    if $globus::_oauth_server {
      globus_connect_config { 'OAuth/Server': value => $globus::_oauth_server }
      globus_connect_config { 'OAuth/ServerBehindNAT': value => $globus::oauth_server_behind_firewall }
      if $globus::oauth_stylesheet {
        globus_connect_config { 'OAuth/Stylesheet': value => $globus::oauth_stylesheet }
      }
      if $globus::oauth_logo {
        globus_connect_config { 'OAuth/Logo': value => $globus::oauth_logo }
      }
    }
  }
  if String($globus::version) == '5' {
    $endpoint_setup_args = globus::endpoint_setup_args({
      display_name => $globus::display_name,
      client_id => $globus::client_id,
      client_secret => $globus::client_secret,
      owner => $globus::owner,
      deployment_key => $globus::deployment_key,
      organization => $globus::organization,
      keywords => $globus::keywords,
      department => $globus::department,
      contact_email => $globus::contact_email,
      contact_info => $globus::contact_info,
      info_link => $globus::info_link,
      description => $globus::description,
      public => $globus::public,
    })
    $endpoint_setup = "globus-connect-server endpoint setup ${endpoint_setup_args}"
    file { '/root/globus-endpoint-setup':
      ensure    => 'file',
      owner     => 'root',
      group     => 'root',
      mode      => '0700',
      show_diff => false,
      content   => "export GLOBUS_CLIENT_SECRET=${globus::client_secret}\n${endpoint_setup}\n"
    }
    $node_setup_args = globus::node_setup_args({
      client_id => $globus::client_id,
      deployment_key => $globus::deployment_key,
      incoming_port_range => $globus::incoming_port_range,
      outgoing_port_range => $globus::outgoing_port_range,
      ip_address => $globus::_ip_address,
      export_node => $globus::export_node,
      import_node => $globus::import_node,
    })
    $node_setup = "globus-connect-server node setup ${node_setup_args}"
    file { '/root/globus-node-setup':
      ensure    => 'file',
      owner     => 'root',
      group     => 'root',
      mode      => '0700',
      show_diff => false,
      content   => "export GLOBUS_CLIENT_SECRET=${globus::client_secret}\n${node_setup}\n"
    }
    if $globus::run_setup_commands {
      exec { 'globus-endpoint-setup':
        path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        command     => $endpoint_setup,
        environment => ["GLOBUS_CLIENT_SECRET=${globus::client_secret}"],
        creates     => $globus::deployment_key,
        logoutput   => true,
      }
      exec { 'globus-node-setup':
        path        => '/usr/bin:/bin:/usr/sbin:/sbin',
        command     => $node_setup,
        environment => ["GLOBUS_CLIENT_SECRET=${globus::client_secret}"],
        creates     => '/var/lib/globus-connect-server/info.json',
        logoutput   => true,
        require     => Exec['globus-endpoint-setup'],
      }
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

  if String($globus::version) == '4' and $globus::first_gridftp_callback {
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
    if String($globus::version) == '4' and $globus::include_io_server {
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

    if String($globus::version) == '5' or $globus::include_io_server {
      firewall { '500 allow GridFTP data channels':
        action => 'accept',
        dport  => join($globus::gridftp_incoming_port_range, '-'),
        proto  => 'tcp',
      }
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
