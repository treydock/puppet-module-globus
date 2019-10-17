# @summary Default values
# @api private
class globus::params {

  case $::osfamily {
    'RedHat': {
      $releasever = $facts['os']['release']['major']
      if $::operatingsystem == 'Fedora' {
        $url_os = 'fedora'
      } else {
        $url_os = 'el'
      }
      $repo_baseurl = "https://downloads.globus.org/toolkit/gt6/stable/rpm/${url_os}/${releasever}/\$basearch/"
      $repo_baseurl_v5 = "https://downloads.globus.org/globus-connect-server/stable/rpm/${url_os}/${releasever}/\$basearch/"
      $release_url = 'https://downloads.globus.org/toolkit/globus-connect-server/globus-connect-server-repo-latest.noarch.rpm'
      $yum_priorities_package = 'yum-plugin-priorities'
    }

    default: {
      fail("Unsupported osfamily: ${::osfamily}, module ${module_name} only support osfamily RedHat")
    }
  }

}
