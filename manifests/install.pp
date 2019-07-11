# @summary manage Globus install
# @api private
class globus::install {

  if $globus::version == '4' {
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

  if $globus::version == '5' {
    package { $globus::package_name:
      ensure => 'present',
    }
  }

}
