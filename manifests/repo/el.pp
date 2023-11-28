# @summary Manage globus repo
# @api private
class globus::repo::el {
  if $globus::enable_testing_repos {
    $testing_enabled = '1'
  } else {
    $testing_enabled = '0'
  }

  exec { 'RPM-GPG-KEY-Globus':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "wget -qO- ${globus::release_url} | rpm2cpio - | cpio -i --quiet --to-stdout ./etc/pki/rpm-gpg/RPM-GPG-KEY-Globus > /etc/pki/rpm-gpg/RPM-GPG-KEY-Globus",
    creates => '/etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
  }

  file { '/etc/yum.repos.d/Globus-Toolkit.repo':
    ensure => 'absent',
  }
  file { '/etc/yum.repos.d/Globus-Toolkit-6-Testing.repo':
    ensure => 'absent',
  }

  yumrepo { 'globus-connect-server-5':
    descr          => 'Globus-Connect-Server-5',
    baseurl        => $globus::gcs_repo_baseurl,
    failovermethod => 'priority',
    priority       => '98',
    enabled        => '1',
    gpgcheck       => '1',
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
    require        => Exec['RPM-GPG-KEY-Globus'],
  }

  yumrepo { 'globus-connect-server-5-testing':
    descr          => 'Globus-Connect-Server-5-Testing',
    baseurl        => $globus::gcs_repo_testing_baseurl,
    failovermethod => 'priority',
    priority       => '98',
    enabled        => $testing_enabled,
    gpgcheck       => '1',
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
    require        => Exec['RPM-GPG-KEY-Globus'],
  }
}
