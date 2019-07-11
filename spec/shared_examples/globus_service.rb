shared_examples_for 'globus::service' do |facts|
  it do
    is_expected.to contain_service('globus-gridftp-server').with(ensure: 'running',
                                                                 enable: 'true',
                                                                 hasstatus: 'true',
                                                                 hasrestart: 'true')
  end

  context 'when manage_service => false' do
    let(:params) { { manage_service: false } }

    it { is_expected.not_to contain_service('globus-gridftp-server') }
  end

  context 'version => 5', if: support_v5(facts) do
    let(:pre_condition) { "class { 'globus::params': version => '5' }" }

    it { is_expected.to contain_service('globus-gridftp-server') }
  end
end
