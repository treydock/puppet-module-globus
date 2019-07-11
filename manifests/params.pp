# @summary Default values
# @api private
# @param version
class globus::params (
  Variant[Enum['4','5'],Integer[4,5]] $version = '4',
) {

  case $::osfamily {
    'RedHat': {
      $releasever = $facts['os']['release']['major']
      if $::operatingsystem == 'Fedora' {
        $url_os = 'fedora'
      } else {
        $url_os = 'el'
        if versioncmp($releasever, '6') <= 0 {
          if String($version) == '5' {
            fail("${module_name}: Version 5 is not supported on OS major release ${releasever}")
          }
        }
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
