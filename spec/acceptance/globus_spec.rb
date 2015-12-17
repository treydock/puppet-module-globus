require 'spec_helper_acceptance'

describe 'yum_cron class:' do
  context 'with default parameters' do
    it 'should run successfully' do
      pp = "
        class { 'globus':
          globus_user         => 'foo',
          globus_password     => 'bar',
          endpoint_name       => 'test',
          run_setup_commands  => false,
          manage_firewall     => #{!(default['hypervisor'] =~ /docker/)},
        }
      "

      apply_manifest(pp, :catch_failures => true)
      apply_manifest(pp, :catch_changes => true)
    end

    describe yumrepo('Globus-Toolkit') do
      it { should exist }
      it { should be_enabled }
    end

    describe package('globus-connect-server-io') do
      it { should be_installed }
    end

    describe package('globus-connect-server-id') do
      it { should be_installed }
    end

    describe file('/etc/globus-connect-server.conf') do
      it { should be_file }
      it { should be_owned_by 'root' }
      it { should be_grouped_into 'root' }
      it { should be_mode 600 }
      its(:content) { should match /^User = foo$/ }
      its(:content) { should match /^Password = bar$/ }
      its(:content) { should match /^Name = test$/ }
      its(:content) { should match /^Public = False$/ }
      its(:content) { should match /^DefaultDirectory = \/~\/$/ }
      #its(:content) { should match /^$/ }
    end
  end
end
