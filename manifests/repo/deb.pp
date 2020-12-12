# @summary Manage globus repo
# @api private
class globus::repo::deb {

  $release_name = basename($globus::release_url)
  $repo_dir     = '/usr/share/globus-toolkit-repo'
  $release_path = "${repo_dir}/${release_name}"
  $repo_key     = "${repo_dir}/RPM-GPG-KEY-Globus"
  if String($globus::version) == '5' {
    $gcs_ensure = 'present'
  } else {
    $gcs_ensure = 'absent'
  }

  file { $repo_dir:
    ensure => 'directory',
    owner  => 'root',
    group  => 'root',
    mode   => '0755',
  }

  exec { 'curl-globus-release':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "curl -Ls --show-error -o ${release_path} ${globus::release_url}",
    creates => $release_path,
    require => File[$repo_dir],
    before  => Exec['extract-globus-repo-key'],
  }

  exec { 'extract-globus-repo-key':
    path    => '/usr/bin:/bin:/usr/sbin:/sbin',
    command => "dpkg --fsys-tarfile ${release_path} | tar xOf - .${repo_key} > ${repo_key}",
    creates => $repo_key,
  }

  apt::source { 'globus-toolkit-6-stable':
    ensure   => 'present',
    location => $globus::toolkit_repo_baseurl,
    release  => $facts['os']['distro']['codename'],
    repos    => 'contrib',
    include  => {
      'src' => true,
    },
    key      => {
      'id'     => '66A86341D3CDB1B26BE4D46F44AE7EC2FAF24365',
      'source' => $repo_key,
    },
    require  => Exec['extract-globus-repo-key'],
  }

  apt::source { 'globus-toolkit-6-testing':
    ensure   => 'present',
    location => $globus::toolkit_repo_testing_baseurl,
    release  => $facts['os']['distro']['codename'],
    repos    => 'contrib',
    include  => {
      'src' => true,
    },
    key      => {
      'id'     => '66A86341D3CDB1B26BE4D46F44AE7EC2FAF24365',
      'source' => $repo_key,
    },
    require  => Exec['extract-globus-repo-key'],
  }

  apt::source { 'globus-connect-server-stable':
    ensure   => $gcs_ensure,
    location => $globus::gcs_repo_baseurl,
    release  => $facts['os']['distro']['codename'],
    repos    => 'contrib',
    include  => {
      'src' => true,
    },
    key      => {
      'id'     => '66A86341D3CDB1B26BE4D46F44AE7EC2FAF24365',
      'source' => $repo_key,
    },
    require  => Exec['extract-globus-repo-key'],
  }

  apt::source { 'globus-connect-server-testing':
    ensure   => $gcs_ensure,
    location => $globus::gcs_repo_testing_baseurl,
    release  => $facts['os']['distro']['codename'],
    repos    => 'contrib',
    include  => {
      'src' => true,
    },
    key      => {
      'id'     => '66A86341D3CDB1B26BE4D46F44AE7EC2FAF24365',
      'source' => $repo_key,
    },
    require  => Exec['extract-globus-repo-key'],
  }
}
