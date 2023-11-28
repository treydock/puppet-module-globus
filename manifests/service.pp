# @summary Manage Globus service
# @api private
class globus::service {
  if $globus::manage_service {
    # Only attempt to start GCS services if Globus node is setup
    if $facts['globus_node_setup'] {
      $gcs_ensure = 'running'
      $gridftp_ensure = 'running'
    } else {
      $gridftp_ensure = undef
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
