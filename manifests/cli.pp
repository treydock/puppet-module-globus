# @summary Manage Globus CLI
#
# @example
#   include ::globus::cli
#
# @param ensure
#   The ensure parameter for PIP installed CLI
# @param install_path
#   Path to install Globus CLI virtualenv
# @param manage_python
#   Boolean to set if Python is managed by this class
# @param virtualenv_provider
#   Virtualenv command to use
# @param pip_provider
#   Pip command to use
class globus::cli (
  String[1] $ensure = 'present',
  Stdlib::Absolutepath $install_path = '/opt/globus-cli',
  Boolean $manage_python = true,
  String $virtualenv_provider = '/usr/bin/virtualenv',
  String $pip_provider = 'pip',
) {

  if $manage_python {
    include globus::python
    Package['virtualenv'] -> Python::Virtualenv['globus-cli']
  }

  python::virtualenv { 'globus-cli':
    ensure     => 'present',
    version    => $globus::python::version,
    virtualenv => $virtualenv_provider,
    venv_dir   => $install_path,
    distribute => false,
  }
  -> python::pip { 'globus-cli':
    ensure       => $ensure,
    pip_provider => $pip_provider,
    virtualenv   => $install_path,
  }

  file { '/usr/bin/globus':
    ensure  => 'link',
    target  => "${install_path}/bin/globus",
    require => Python::Pip['globus-cli'],
  }

}
