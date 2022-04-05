require 'spec_helper_acceptance'

describe 'globus::sdk class:' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = 'include globus::sdk'

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe command("/opt/globus-sdk/bin/python -c 'import globus_sdk'") do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
