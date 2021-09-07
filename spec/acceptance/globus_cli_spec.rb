require 'spec_helper_acceptance'

describe 'globus::cli class:', unless: fact('os.release.major') == '20.04' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = "class { 'globus::cli': timer_ensure => 'present' }"

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe command('globus --version') do
      its(:exit_status) { is_expected.to eq 0 }
    end
    describe command('globus-timer --version') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
