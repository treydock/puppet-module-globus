# @summary Manage Globus service
# @api private
class globus::service {
  if $globus::include_io_server and String($globus::version) == '4' and $globus::manage_service {
    service { 'globus-gridftp-server':
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }

  if String($globus::version) == '5' and $globus::manage_service {
    # Only attempt to start GCS services if Globus node is setup
    if $facts['globus_node_setup'] {
      $gcs_ensure = 'running'
      $gridftp_ensure = 'running'
    } else {
      # EL8 seems to have issues starting on fresh install
      if $facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'], '8') == 0 {
        $gridftp_ensure = undef
      } else {
        $gridftp_ensure = 'running'
      }
      $gcs_ensure = undef
    }
    service { 'globus-gridftp-server':
      ensure     => $gridftp_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
    service { 'gcs_manager':
      ensure     => $gcs_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
    service { 'gcs_manager_assistant':
      ensure     => $gcs_ensure,
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }
}
