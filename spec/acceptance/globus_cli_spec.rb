require 'spec_helper_acceptance'

describe 'globus::cli class:' do
  context 'with default parameters' do
    it 'runs successfully' do
      # Python is too old on Debian 9 for globus-timer-cli
      timer_ensure = if fact('os.name') == 'Debian' && fact('os.release.major') == '9'
                       'absent'
                     else
                       'present'
                     end
      pp = "class { 'globus::cli': timer_ensure => '#{timer_ensure}' }"

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe command('globus --version') do
      its(:exit_status) { is_expected.to eq 0 }
    end
    describe command('globus-timer --version'), unless: (fact('os.name') == 'Debian' && fact('os.release.major') == '9') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
