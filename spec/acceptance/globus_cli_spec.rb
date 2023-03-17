# frozen_string_literal: true

require 'spec_helper_acceptance'

describe 'globus::cli class:', unless: fact('os.name') == 'Debian' && fact('os.release.major') == '9' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = 'include globus::cli'

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end

    describe command('globus version') do
      its(:exit_status) { is_expected.to eq 0 }
    end
  end
end
