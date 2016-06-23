# Private class: See README.md.
class globus::service {

  if $globus::include_io_server and $globus::manage_service {
    service { 'globus-gridftp-server':
      ensure     => 'running',
      enable     => true,
      hasstatus  => true,
      hasrestart => true,
    }
  }

}
