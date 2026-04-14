# frozen_string_literal: true

shared_examples_for 'globus::repo::deb' do |facts|
  let(:release_url) { 'https://downloads.globus.org/globus-connect-server/stable/installers/repo/deb/globus-repo_latest_all.deb' }
  let(:release_path) { '/usr/share/globus-repo/globus-repo_latest_all.deb' }
  let(:repo_key) { '/usr/share/globus-repo/GPG-KEY-Globus-2024' }
  let(:baseurl) { 'https://downloads.globus.org/globus-connect-server/stable/deb' }

  it do
    is_expected.to contain_file('/usr/share/globus-repo').with(
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
      require: 'File[/usr/share/globus-repo]',
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
    is_expected.to contain_apt__source('globus-connect-server-stable').with(
      ensure: 'present',
      location: baseurl,
      release: facts[:os]['distro']['codename'],
      repos: 'contrib',
      include: { 'src' => 'true' },
      key: {
        'id' => '66A86341D3CDB1B26BE4D46F44AE7EC2FAF24365',
        'source' => repo_key,
      },
      require: 'Exec[extract-globus-repo-key]',
    )
  end

  it { is_expected.to contain_apt__source('globus-connect-server-testing').with_ensure('absent') }
end
