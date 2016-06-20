shared_examples_for 'globus::repo::el' do |facts|
  if facts[:operatingsystem] != 'Fedora' && facts[:operatingsystemmajrelease] == '5'
    let(:yum_priorities_package) { 'yum-priorities' }
  else
    let(:yum_priorities_package) { 'yum-plugin-priorities' }
  end

  if facts[:operatingsystem] == 'Fedora'
    let(:descr) { 'Globus-Toolkit-6-fedora' }
    let(:baseurl) { 'http://toolkit.globus.org/ftppub/gt6/stable/rpm/fedora/$releasever/$basearch/' }
  elsif facts[:operatingsystem] == 'RedHat'
    let(:descr) { "Globus-Toolkit-6-el#{facts[:operatingsystemmajrelease]}" }
    let(:baseurl) { "http://toolkit.globus.org/ftppub/gt6/stable/rpm/el/#{facts[:operatingsystemmajrelease]}/$basearch/" }
  else
    let(:descr) { "Globus-Toolkit-6-el#{facts[:operatingsystemmajrelease]}" }
    let(:baseurl) { 'http://toolkit.globus.org/ftppub/gt6/stable/rpm/el/$releasever/$basearch/' }
  end

  it 'installs yum priorities plugin' do
    is_expected.to contain_package(yum_priorities_package)
  end

  it 'installs GPG key' do
    is_expected.to contain_exec('RPM-GPG-KEY-Globus').with({
      :path     => '/usr/bin:/bin:/usr/sbin:/sbin',
      :command  => 'wget -qO- http://toolkit.globus.org/ftppub/globus-connect-server/globus-connect-server-repo-latest.noarch.rpm | rpm2cpio - | cpio -i --quiet --to-stdout ./etc/pki/rpm-gpg/RPM-GPG-KEY-Globus > /etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
      :creates  => '/etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
      :before   => 'Yumrepo[Globus-Toolkit]',
    })
  end

  it 'creates Yumrepo[Globus-Toolkit]' do
    is_expected.to contain_yumrepo('Globus-Toolkit').with({
      :descr          => descr,
      :baseurl        => baseurl,
      :failovermethod => 'priority',
      :priority       => '98',
      :enabled        => '1',
      :gpgcheck       => '1',
      :gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-Globus',
    })
  end
end
