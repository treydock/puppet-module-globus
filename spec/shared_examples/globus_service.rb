shared_examples_for 'globus::service' do |_facts|
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
end
