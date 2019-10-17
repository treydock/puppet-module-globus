shared_examples_for 'globus::install' do |facts|
  it { is_expected.to contain_package('globus-connect-server-io').with_ensure('present') }
  it { is_expected.to contain_package('globus-connect-server-id').with_ensure('present') }
  it { is_expected.not_to contain_package('globus-connect-server-web') }
  it { is_expected.not_to contain_package('globus-connect-server53') }

  context 'version => 5', if: support_v5(facts) do
    let(:params) { { version: '5' } }

    it { is_expected.not_to contain_package('globus-connect-server-io') }
    it { is_expected.not_to contain_package('globus-connect-server-id') }
    it { is_expected.not_to contain_package('globus-connect-server-web') }
    it { is_expected.to contain_package('globus-connect-server53').with_ensure('present') }
  end
end
