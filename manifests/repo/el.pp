# @summary Manage globus repo
# @api private
class globus::repo::el {
  ensure_packages([$globus::params::yum_priorities_package])

  exec { 'RPM-GPG-KEY-Globus':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "wget -qO- ${globus::release_url} | rpm2cpio - | cpio -i --quiet --to-stdout ./etc/pki/rpm-gpg/RPM-GPG-KEY-Globus > /etc/pki/rpm-gpg/RPM-GPG-KEY-Globus",
    creates => '/etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
    before  => Yumrepo['Globus-Toolkit']
  }

  yumrepo { 'Globus-Toolkit':
    descr          => 'Globus-Toolkit-6',
    baseurl        => $globus::repo_baseurl,
    failovermethod => 'priority',
    priority       => '98',
    enabled        => '1',
    gpgcheck       => '1',
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
  }

  if $globus::version == '5' {
    yumrepo { 'globus-connect-server-5':
      descr          => 'Globus-Connect-Server-5',
      baseurl        => $globus::repo_baseurl_v5,
      failovermethod => 'priority',
      priority       => '98',
      enabled        => '1',
      gpgcheck       => '1',
      gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
      require        => Exec['RPM-GPG-KEY-Globus'],
    }
  }

}
