shared_examples_for 'globus::repo::el' do |facts|
  if facts[:operatingsystem] != 'Fedora' && facts[:operatingsystemmajrelease] == '5'
    let(:yum_priorities_package) { 'yum-priorities' }
  else
    let(:yum_priorities_package) { 'yum-plugin-priorities' }
  end

  if facts[:operatingsystem] == 'Fedora'
    let(:descr) { 'Globus-Toolkit-6-fedora' }
    let(:baseurl) { 'https://downloads.globus.org/toolkit/gt6/stable/rpm/fedora/$releasever/$basearch/' }
  elsif facts[:operatingsystem] == 'RedHat'
    let(:descr) { "Globus-Toolkit-6-el#{facts[:operatingsystemmajrelease]}" }
    let(:baseurl) { "https://downloads.globus.org/toolkit/gt6/stable/rpm/el/#{facts[:operatingsystemmajrelease]}/$basearch/" }
  else
    let(:descr) { "Globus-Toolkit-6-el#{facts[:operatingsystemmajrelease]}" }
    let(:baseurl) { 'https://downloads.globus.org/toolkit/gt6/stable/rpm/el/$releasever/$basearch/' }
  end

  it 'installs yum priorities plugin' do
    is_expected.to contain_package(yum_priorities_package)
  end

  it 'creates Yumrepo[Globus-Toolkit]' do
    is_expected.to contain_yumrepo('Globus-Toolkit').with(descr: descr,
                                                          baseurl: baseurl,
                                                          failovermethod: 'priority',
                                                          priority: '98',
                                                          enabled: '1',
                                                          gpgcheck: '1',
                                                          gpgkey: 'https://downloads.globus.org/toolkit/gt6/stable/repo/rpm/RPM-GPG-KEY-Globus')
  end
end
