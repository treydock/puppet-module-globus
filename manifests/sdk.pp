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
  if $manage_python {
    include globus::python
    $venv_python_version = $globus::python::venv_python_version
    $pip_provider = $globus::python::pip_provider
  } else {
    $venv_python_version = undef
    $pip_provider = undef
  }

  python::pyvenv { 'globus-sdk':
    ensure     => 'present',
    version    => $venv_python_version,
    venv_dir   => $install_path,
    systempkgs => true,
    before     => Python::Pip['globus-sdk'],
  }

  python::pip { 'globus-sdk':
    ensure       => $ensure,
    pip_provider => $pip_provider,
    virtualenv   => $install_path,
  }
}
