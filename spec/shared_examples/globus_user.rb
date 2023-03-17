# frozen_string_literal: true

shared_examples_for 'globus::user' do |facts|
  let(:shell) do
    case facts[:os]['family']
    when 'RedHat'
      '/sbin/nologin'
    when 'Debian'
      '/bin/false'
    end
  end

  it do
    is_expected.to contain_group('gcsweb').with(
      ensure: 'present',
      gid: nil,
      system: 'true',
      forcelocal: 'true',
    )
  end

  it do
    is_expected.to contain_user('gcsweb').with(
      ensure: 'present',
      uid: nil,
      gid: 'gcsweb',
      shell: shell,
      home: '/var/lib/globus-connect-server/gcs-manager',
      managehome: 'false',
      system: 'true',
      forcelocal: 'true',
    )
  end

  context 'when manage_user => false' do
    let(:params) { default_params.merge(manage_user: false) }

    it { is_expected.not_to contain_group('gcsweb') }
    it { is_expected.not_to contain_user('gcsweb') }
  end
end
