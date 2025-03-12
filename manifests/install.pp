# @summary manage Globus install
# @api private
class globus::install {
  if $facts['os']['family'] == 'RedHat' and versioncmp($facts['os']['release']['major'], '8') == 0 {
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
