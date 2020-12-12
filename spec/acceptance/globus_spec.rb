require 'spec_helper_acceptance'

describe 'globus class:' do
  context 'with version => 4', if: fact('os.release.major').to_i == 7 do
    it 'runs successfully' do
      pp = "
        class { 'globus':
          version             => '4',
          globus_user         => 'foo',
          globus_password     => 'bar',
          endpoint_name       => 'test',
          run_setup_commands  => false,
          manage_firewall     => false,
        }
      "

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe yumrepo('Globus-Toolkit') do
      it { is_expected.to exist }
      it { is_expected.to be_enabled }
    end

    describe yumrepo('globus-connect-server-5') do
      it { is_expected.to exist }
      it { is_expected.not_to be_enabled }
    end

    describe package('globus-connect-server-io') do
      it { is_expected.to be_installed }
    end

    describe package('globus-connect-server-id') do
      it { is_expected.to be_installed }
    end

    describe package('globus-connect-server54') do
      it { is_expected.not_to be_installed }
    end

    describe file('/etc/globus-connect-server.conf') do
      it { is_expected.to be_file }
      it { is_expected.to be_owned_by 'root' }
      it { is_expected.to be_grouped_into 'root' }
      it { is_expected.to be_mode 600 }
      its(:content) { is_expected.to match %r{^User = foo$} }
      its(:content) { is_expected.to match %r{^Password = bar$} }
      its(:content) { is_expected.to match %r{^Name = test$} }
      its(:content) { is_expected.to match %r{^Public = False$} }
      its(:content) { is_expected.to match %r{^DefaultDirectory = /~/$} }
    end

    describe service('globus-gridftp-server') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe service('gcs_manager') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end

    describe service('gcs_manager_assistant') do
      it { is_expected.not_to be_enabled }
      it { is_expected.not_to be_running }
    end
  end

  context 'with v5 parameters' do
    it 'runs successfully' do
      pp = "
      class { 'globus':
        display_name        => 'REPLACE My Site Globus',
        client_id           => 'REPLACE-client-id-from-globus',
        client_secret       => 'REPLACE-client-id-from-globus',
        owner               => 'REPLACE-user@example.com',
        run_setup_commands  => false,
        manage_firewall     => false,
      }
      "
      on hosts, 'yum -y remove globus\\*'
      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe yumrepo('Globus-Toolkit') do
      it { is_expected.to exist }
      it { is_expected.to be_enabled }
    end

    describe yumrepo('globus-connect-server-5') do
      it { is_expected.to exist }
      it { is_expected.to be_enabled }
    end

    describe package('globus-connect-server-io') do
      it { is_expected.not_to be_installed }
    end

    describe package('globus-connect-server-id') do
      it { is_expected.not_to be_installed }
    end

    describe package('globus-connect-server54') do
      it { is_expected.to be_installed }
    end

    describe service('globus-gridftp-server') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe service('gcs_manager') do
      it { is_expected.to be_enabled }
      it { is_expected.to be_running }
    end

    describe service('gcs_manager_assistant') do
      it { is_expected.to be_enabled }
      it { is_expected.not_to be_running }
    end
  end
end
