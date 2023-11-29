# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'globus class:' do
  context 'with v5 parameters' do
    it 'runs successfully' do
      pp = "
      class { 'globus':
        display_name        => 'REPLACE My Site Globus',
        owner               => 'REPLACE-user@example.com',
        organization        => 'REPLACE-My Site',
        run_setup_commands  => false,
        manage_firewall     => false,
      }
      "
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe yumrepo('globus-connect-server-5'), if: fact('os.family') == 'RedHat' do
      it { is_expected.to exist }
      it { is_expected.to be_enabled }
    end

    describe package('globus-connect-server54') do
      it { is_expected.to be_installed }
    end

    describe service('globus-gridftp-server') do
      it { is_expected.to be_enabled }
      it { is_expected.not_to be_running }
    end

    describe service('gcs_manager') do
      it { is_expected.to be_enabled }
      it { is_expected.not_to be_running }
    end

    describe service('gcs_manager_assistant') do
      it { is_expected.to be_enabled }
      it { is_expected.not_to be_running }
    end
  end
end
