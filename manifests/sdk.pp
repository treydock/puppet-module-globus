# @summary Manage Globus SDK
#
# @example
#   include globus::sdk
#
# @param ensure
#   The ensure parameter for PIP installed SDK
# @param install_path
#   Path to install Globus CLI virtualenv
# @param manage_python
#   Boolean to set if Python is managed by this class
class globus::sdk (
  String[1] $ensure = 'present',
  Stdlib::Absolutepath $install_path = '/opt/globus-sdk',
  Boolean $manage_python = true,
) {

  $releasever = $facts['os']['release']['major']
  if versioncmp($releasever, '6') <= 0 {
    fail("${module_name}: CLI is not supported on OS major release ${releasever}")
  }

  if $manage_python {
    class { 'python':
      virtualenv => 'present',
    }
    Package['virtualenv'] -> Python::Virtualenv['globus-sdk']
  }

  python::virtualenv { 'globus-sdk':
    ensure     => 'present',
    venv_dir   => $install_path,
    distribute => false,
  }
  -> python::pip { 'globus-sdk':
    ensure     => $ensure,
    virtualenv => $install_path,
  }
}
