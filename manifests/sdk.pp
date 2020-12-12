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
# @param virtualenv_provider
#   Virtualenv command to use
# @param pip_provider
#   Pip command to use
class globus::sdk (
  String[1] $ensure = 'present',
  Stdlib::Absolutepath $install_path = '/opt/globus-sdk',
  Boolean $manage_python = true,
  String $virtualenv_provider = '/usr/bin/virtualenv',
  String $pip_provider = 'pip',
) {

  if $facts.dig('os','name') == 'Ubuntu' and $facts.dig('os','release','major') == '20.04' {
    fail('globus::cli: Not supported on this operating system')
  }

  if $manage_python {
    include globus::python
    $virtualenv_require = Package['virtualenv']
  } else {
    $virtualenv_require = undef
  }

  if $facts['os']['family'] == 'RedHat' {
    python::virtualenv { 'globus-sdk':
      ensure     => 'present',
      version    => $globus::python::version,
      virtualenv => $virtualenv_provider,
      venv_dir   => $install_path,
      distribute => false,
      before     => Python::Pip['globus-sdk'],
      require    => $virtualenv_require,
    }
  } elsif $facts['os']['family'] == 'Debian' {
    python::pyvenv { 'globus-sdk':
      ensure   => 'present',
      version  => $globus::python::version,
      venv_dir => $install_path,
      before   => Python::Pip['globus-sdk'],
      require  => $virtualenv_require,
    }
  } else {
    fail('globus::sdk: Unsupported OS family')
  }

  python::pip { 'globus-sdk':
    ensure       => $ensure,
    pip_provider => $pip_provider,
    virtualenv   => $install_path,
  }
}
