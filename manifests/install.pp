# @summary manage Globus install
# @api private
class globus::install {
  if String($globus::version) == '4' {
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

  if String($globus::version) == '5' {
    case $facts['os']['release']['major'] {
      '8':  {
        exec { 'dnf reset':
          command => '/bin/dnf module -y disable mod_auth_openidc',
          unless  => '/bin/rpm -aq | grep $globus::package_name',
        }
        package { $globus::package_name:
          ensure => 'present',
        }
      }
      default: {
        package { $globus::package_name:
          ensure => 'present',
        }
      }
    }
  }
}
