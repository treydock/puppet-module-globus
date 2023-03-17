# frozen_string_literal: true

shared_examples_for 'globus::repo::elv4' do |facts|
  if facts[:operatingsystem] == 'Fedora'
    let(:url_os) { 'fedora' }
  else
    let(:url_os) { 'el' }
  end
  let(:baseurl) { "https://downloads.globus.org/toolkit/gt6/stable/rpm/#{url_os}/#{facts[:operatingsystemmajrelease]}/$basearch/" }
  let(:baseurl_gcs) { "https://downloads.globus.org/globus-connect-server/stable/rpm/#{url_os}/#{facts[:operatingsystemmajrelease]}/$basearch/" }

  it 'installs yum priorities plugin' do
    is_expected.to contain_package('yum-plugin-priorities')
  end

  it 'installs GPG key' do
    is_expected.to contain_exec('RPM-GPG-KEY-Globus')
      .with(path: '/usr/bin:/bin:/usr/sbin:/sbin',
            command: 'wget -qO- https://downloads.globus.org/toolkit/globus-connect-server/globus-connect-server-repo-latest.noarch.rpm | rpm2cpio - | cpio -i --quiet --to-stdout ./etc/pki/rpm-gpg/RPM-GPG-KEY-Globus > /etc/pki/rpm-gpg/RPM-GPG-KEY-Globus', # rubocop:disable Metrics/LineLength
            creates: '/etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
            before: 'Yumrepo[Globus-Toolkit]')
  end

  it 'creates Yumrepo[Globus-Toolkit]' do
    is_expected.to contain_yumrepo('Globus-Toolkit').with(
      descr: 'Globus-Toolkit-6',
      baseurl: baseurl,
      failovermethod: 'priority',
      priority: '98',
      enabled: '1',
      gpgcheck: '1',
      gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
    )
  end

  it { is_expected.to contain_yumrepo('Globus-Toolkit-6-Testing').with_enabled('0') }

  it 'creates Yumrepo[globus-connect-server-5' do
    is_expected.to contain_yumrepo('globus-connect-server-5').with(
      descr: 'Globus-Connect-Server-5',
      baseurl: baseurl_gcs,
      failovermethod: 'priority',
      priority: '98',
      enabled: '0',
      gpgcheck: '1',
      gpgkey: 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
      require: 'Exec[RPM-GPG-KEY-Globus]',
    )
  end

  it { is_expected.to contain_yumrepo('globus-connect-server-5-testing').with_enabled('0') }
end
