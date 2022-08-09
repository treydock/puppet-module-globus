# @summary Manage Globus Python dependency
# @api private
class globus::python (
  String $version = '3',
  Array $package_dependencies = [],
  String $pip_provider = 'pip',
  String $venv_python_version = 'system',
) {
  class { 'python':
    version => $version,
    dev     => 'present',
    venv    => 'present',
  }
}
