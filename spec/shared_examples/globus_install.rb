# frozen_string_literal: true

shared_examples_for 'globus::install' do |facts|
  it { is_expected.not_to contain_package('globus-connect-server-io') }
  it { is_expected.not_to contain_package('globus-connect-server-id') }
  it { is_expected.not_to contain_package('globus-connect-server-web') }

  if facts[:os]['family'] == 'RedHat' && facts[:os]['release']['major'].to_i == 8
    it do
      is_expected.to contain_package('mod_auth_openidc-dnf-module').with(
        ensure: 'disabled',
        name: 'mod_auth_openidc',
        provider: 'dnfmodule',
        before: 'Package[globus-connect-server54]',
      )
    end
  else
    it { is_expected.not_to contain_package('mod_auth_openidc-dnf-module') }
  end
  it { is_expected.to contain_package('globus-connect-server54').with_ensure('present') }
end
