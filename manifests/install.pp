# @summary manage Globus install
# @api private
class globus::install {

  if $globus::include_io_server {
    package { 'globus-connect-server-io':
      ensure  => 'present',
    }
  }

  if $globus::include_id_server {
    package { 'globus-connect-server-id':
      ensure  => 'present',
    }
  }

  if $globus::include_oauth_server {
    package { 'globus-connect-server-web':
      ensure  => 'present',
    }
  }

}
