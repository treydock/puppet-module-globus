# @summary Manage Globus Python dependency
# @api private
class globus::python (
  String $version = 'system',
) {
  class { 'python':
    version    => $version,
    virtualenv => 'present',
  }
}
