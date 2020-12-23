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
class globus::cli (
  String[1] $ensure = 'present',
  Stdlib::Absolutepath $install_path = '/opt/globus-cli',
  Boolean $manage_python = true,
) {

  if $facts.dig('os','name') == 'Ubuntu' and $facts.dig('os','release','major') == '20.04' {
    fail('globus::cli: Not supported on this operating system')
  }

  if $manage_python {
    include globus::python
  }

  python::pyvenv { 'globus-cli':
    ensure     => 'present',
    version    => $globus::python::venv_python_version,
    venv_dir   => $install_path,
    systempkgs => true,
    before     => Python::Pip['globus-cli'],
  }

  python::pip { 'globus-cli':
    ensure       => $ensure,
    pip_provider => $globus::python::pip_provider,
    virtualenv   => $install_path,
  }

  file { '/usr/bin/globus':
    ensure  => 'link',
    target  => "${install_path}/bin/globus",
    require => Python::Pip['globus-cli'],
  }

}
