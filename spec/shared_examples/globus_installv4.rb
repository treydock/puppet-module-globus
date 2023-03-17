# frozen_string_literal: true

shared_examples_for 'globus::installv4' do |_facts|
  it { is_expected.to contain_package('globus-connect-server-io').with_ensure('present') }
  it { is_expected.to contain_package('globus-connect-server-id').with_ensure('present') }
  it { is_expected.not_to contain_package('globus-connect-server-web') }
  it { is_expected.not_to contain_package('globus-connect-server54') }
end
