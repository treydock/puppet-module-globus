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
    if $facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'], '8') >= 0 {
      package { 'mod_auth_openidc-dnf-module':
        ensure   => 'disabled',
        name     => 'mod_auth_openidc',
        provider => 'dnfmodule',
        before   => Package[$globus::package_name],
      }
    }
    package { $globus::package_name:
      ensure => 'present',
    }
  }
}
