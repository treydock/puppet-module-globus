# frozen_string_literal: true

shared_examples_for 'globus::repo::el' do |facts|
  if facts[:os]['name'] == 'Fedora'
    let(:url_os) { 'fedora' }
  else
    let(:url_os) { 'el' }
  end
  let(:baseurl) { "https://downloads.globus.org/globus-connect-server/stable/rpm/#{url_os}/#{facts[:os]['release']['major']}/$basearch/" }

  it 'installs GPG key' do
    is_expected.to contain_exec('RPM-GPG-KEY-Globus-2024')
      .with(path: '/usr/bin:/bin:/usr/sbin:/sbin',
            command: 'wget -qO- https://downloads.globus.org/globus-connect-server/stable/installers/repo/rpm/globus-repo-latest.noarch.rpm | rpm2cpio - | cpio -i --quiet --to-stdout ./etc/pki/rpm-gpg/RPM-GPG-KEY-Globus-2024 > /etc/pki/rpm-gpg/RPM-GPG-KEY-Globus-2024', # rubocop:disable Metrics/LineLength
            creates: '/etc/pki/rpm-gpg/RPM-GPG-KEY-Globus-2024',)
  end

  it 'creates Yumrepo[globus-connect-server-5' do
    is_expected.to contain_yumrepo('globus-connect-server-5').with(
      descr: 'Globus-Connect-Server-5',
      baseurl: baseurl,
      failovermethod: 'priority',
      priority: '98',
      enabled: '1',
      gpgcheck: '1',
      gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Globus-2024',
      require: 'Exec[RPM-GPG-KEY-Globus-2024]',
    )
  end

  it { is_expected.to contain_yumrepo('globus-connect-server-5-testing').with_enabled('0') }
end
