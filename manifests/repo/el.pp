# @summary Manage globus repo
# @api private
class globus::repo::el {
  ensure_packages([$globus::params::yum_priorities_package])

  yumrepo { 'Globus-Toolkit':
    descr          => $globus::repo_descr,
    baseurl        => $globus::repo_baseurl,
    failovermethod => 'priority',
    priority       => '98',
    enabled        => '1',
    gpgcheck       => '1',
    gpgkey         => $globus::gpg_key_url,
  }
}
