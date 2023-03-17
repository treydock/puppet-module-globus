# frozen_string_literal: true

shared_examples_for 'globus::service' do |os_facts|
  let(:gridftp_ensure) do
    if os_facts[:os]['release']['major'].to_s == '8'
      nil
    else
      'running'
    end
  end

  it do
    is_expected.to contain_service('globus-gridftp-server').with(
      ensure: gridftp_ensure,
      enable: 'true',
      hasstatus: 'true',
      hasrestart: 'true',
    )
  end

  it do
    is_expected.to contain_service('gcs_manager').with(
      ensure: nil,
      enable: 'true',
      hasstatus: 'true',
      hasrestart: 'true',
    )
  end

  it do
    is_expected.to contain_service('gcs_manager_assistant').with(
      ensure: nil,
      enable: 'true',
      hasstatus: 'true',
      hasrestart: 'true',
    )
  end

  context 'when manage_service => false' do
    let(:params) { default_params.merge(manage_service: false) }

    it { is_expected.not_to contain_service('globus-gridftp-server') }
    it { is_expected.not_to contain_service('gcs_manager') }
    it { is_expected.not_to contain_service('gcs_manager_assistant') }
  end

  context 'when globus_node_setup is true' do
    let(:facts) { os_facts.merge(globus_node_setup: true) }

    it { is_expected.to contain_service('globus-gridftp-server').with_ensure('running') }
    it { is_expected.to contain_service('gcs_manager').with_ensure('running') }
    it { is_expected.to contain_service('gcs_manager_assistant').with_ensure('running') }
  end
end
