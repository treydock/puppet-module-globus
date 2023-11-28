# @summary Manage globus user and group
# @api private
class globus::user {
  if $globus::osfamily == 'Debian' {
    $shell = '/bin/false'
  } else {
    $shell = '/sbin/nologin'
  }

  if $globus::manage_user {
    group { 'gcsweb':
      ensure     => 'present',
      gid        => $globus::group_gid,
      system     => true,
      forcelocal => true,
    }

    user { 'gcsweb':
      ensure     => 'present',
      uid        => $globus::user_uid,
      gid        => 'gcsweb',
      shell      => $shell,
      home       => '/var/lib/globus-connect-server/gcs-manager',
      managehome => false,
      system     => true,
      forcelocal => true,
    }
  }
}
