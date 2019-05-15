shared_examples_for 'globus::install' do |_facts|
  it { is_expected.to contain_package('globus-connect-server-io').with_ensure('present') }
  it { is_expected.to contain_package('globus-connect-server-id').with_ensure('present') }
  it { is_expected.not_to contain_package('globus-connect-server-web') }
end
