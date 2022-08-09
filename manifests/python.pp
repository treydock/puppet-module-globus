# @summary Manage Globus Python dependency
# @api private
class globus::python (
  String $version = '3',
  Array $package_dependencies = [],
  String $pip_provider = 'pip',
  Optional[String] $venv_ensure = undef,
  String $venv_python_version = 'system',
) {
  class { 'python':
    version => $version,
    dev     => 'present',
    venv    => $venv_ensure,
  }
}
