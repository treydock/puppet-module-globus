shared_examples_for 'globus::install' do |_facts|
  it { is_expected.not_to contain_package('globus-connect-server-io') }
  it { is_expected.not_to contain_package('globus-connect-server-id') }
  it { is_expected.not_to contain_package('globus-connect-server-web') }
  it { is_expected.to contain_package('globus-connect-server54').with_ensure('present') }
end
