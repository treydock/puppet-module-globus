shared_examples_for 'globus::servicev4' do |_facts|
  it do
    is_expected.to contain_service('globus-gridftp-server').with(ensure: 'running',
                                                                 enable: 'true',
                                                                 hasstatus: 'true',
                                                                 hasrestart: 'true')
  end

  context 'when manage_service => false' do
    let(:params) { default_params.merge(manage_service: false) }

    it { is_expected.not_to contain_service('globus-gridftp-server') }
  end
end
