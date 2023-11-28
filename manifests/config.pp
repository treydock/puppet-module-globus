# @summary Manage globus configs
# @api private
class globus::config {
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
    content   => "export GLOBUS_CLIENT_SECRET=${globus::client_secret}\n${endpoint_setup}\n",
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
    content   => "export GLOBUS_CLIENT_SECRET=${globus::client_secret}\n${node_setup}\n",
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
      unless      => 'test -s /var/lib/globus-connect-server/info.json',
      logoutput   => true,
      require     => Exec['globus-endpoint-setup'],
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

  if $globus::manage_firewall {
    firewall { '500 allow HTTPS':
      action => 'accept',
      dport  => '443',
      proto  => 'tcp',
    }

    firewall { '500 allow GridFTP data channels':
      action => 'accept',
      dport  => join($globus::incoming_port_range, '-'),
      proto  => 'tcp',
    }
  }
}
