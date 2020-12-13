require 'spec_helper_acceptance'

describe 'globus::cli class:', unless: fact('os.release.major') == '20.04' do
  context 'with default parameters' do
    it 'runs successfully' do
      pp = 'include globus::cli'

      apply_manifest(pp, catch_failures: true)
      apply_manifest(pp, catch_changes: true)
    end
  end
end
