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
  if $manage_python {
    include globus::python
    $venv_python_version = $globus::python::venv_python_version
    $pip_provider = $globus::python::pip_provider
  } else {
    $venv_python_version = undef
    $pip_provider = undef
  }

  python::pyvenv { 'globus-cli':
    ensure     => 'present',
    version    => $venv_python_version,
    venv_dir   => $install_path,
    systempkgs => true,
    before     => Python::Pip['globus-cli'],
  }

  python::pip { 'globus-cli':
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
