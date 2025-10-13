# @summary Manage Globus Timer
#
# @example
#   include ::globus::timer
#
# @param ensure
#   The ensure parameter for PIP installed globus-timer-cli
# @param install_path
#   Path to install Globus Timer CLI virtualenv
# @param manage_python
#   Boolean to set if Python is managed by this class
class globus::timer (
  String[1] $ensure = 'present',
  Stdlib::Absolutepath $install_path = '/opt/globus-timer',
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

  python::pyvenv { 'globus-timer':
    ensure     => 'present',
    version    => $venv_python_version,
    venv_dir   => $install_path,
    systempkgs => true,
    before     => Python::Pip['globus-timer-cli'],
  }

  python::pip { 'globus-timer-cli':
    ensure       => $ensure,
    pip_provider => $pip_provider,
    virtualenv   => $install_path,
  }
  file { '/usr/bin/globus-timer':
    ensure  => 'link',
    target  => "${install_path}/bin/globus-timer",
    require => Python::Pip['globus-timer-cli'],
  }
}
