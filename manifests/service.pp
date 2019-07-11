# @summary Manage Globus service
# @api private
class globus::service {

  if ($globus::include_io_server or $globus::version == '5') and $globus::manage_service {
    service { 'globus-gridftp-server':
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}
