require 'spec_helper_acceptance'

describe 'globus::cli class:', unless: fact('os.release.major') == '20.04' do
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
    describe command('globus-timer --version'), unless: (fact('os.family') == 'Debian' && ['9', '20.04'].include?(fact('os.release.major'))) do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
