# frozen_string_literal: true

shared_examples_for 'globus::repo::debv4' do |facts|
  let(:release_url) { 'http://downloads.globus.org/toolkit/gt6/stable/installers/repo/deb/globus-toolkit-repo_latest_all.deb' }
  let(:release_path) { '/usr/share/globus-toolkit-repo/globus-toolkit-repo_latest_all.deb' }
  let(:repo_key) { '/usr/share/globus-toolkit-repo/RPM-GPG-KEY-Globus' }
  let(:baseurl) { 'https://downloads.globus.org/toolkit/gt6/stable/deb' }
  let(:baseurl_gcs) { 'https://downloads.globus.org/globus-connect-server/stable/deb' }

  it do
    is_expected.to contain_file('/usr/share/globus-toolkit-repo').with(
      ensure: 'directory',
      owner: 'root',
      group: 'root',
      mode: '0755',
    )
  end

  it do
    is_expected.to contain_exec('curl-globus-release').with(
      path: '/usr/bin:/bin:/usr/sbin:/sbin',
      command: "curl -Ls --show-error -o #{release_path} #{release_url}",
      creates: release_path,
      require: 'File[/usr/share/globus-toolkit-repo]',
      before: 'Exec[extract-globus-repo-key]',
    )
  end

  it do
    is_expected.to contain_exec('extract-globus-repo-key').with(
      path: '/usr/bin:/bin:/usr/sbin:/sbin',
      command: "dpkg --fsys-tarfile #{release_path} | tar xOf - .#{repo_key} > #{repo_key}",
      creates: repo_key,
    )
  end

  it do
    is_expected.to contain_apt__source('globus-toolkit-6-stable').with(
      ensure: 'present',
      location: baseurl,
      release: facts[:os]['distro']['codename'],
      repos: 'contrib',
      include: { 'src' => 'true' },
      key: {
        'id' => '66A86341D3CDB1B26BE4D46F44AE7EC2FAF24365',
        'source' => repo_key
      },
      require: 'Exec[extract-globus-repo-key]',
    )
  end

  it do
    is_expected.to contain_apt__source('globus-connect-server-stable').with(
      ensure: 'absent',
      location: baseurl_gcs,
      release: facts[:os]['distro']['codename'],
      repos: 'contrib',
      include: { 'src' => 'true' },
      key: {
        'id' => '66A86341D3CDB1B26BE4D46F44AE7EC2FAF24365',
        'source' => repo_key
      },
      require: 'Exec[extract-globus-repo-key]',
    )
  end
end
