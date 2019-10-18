require 'spec_helper'

describe 'globus::cli' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      unless support_cli(facts)
        skip('CLI not supported')
        next
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('globus::cli') }

      it { is_expected.to contain_class('python').with_virtualenv('present') }

      it do
        is_expected.to contain_python__virtualenv('/opt/globus-cli').with('ensure' => 'present',
                                                                          'distribute' => 'false')
      end

      it do
        is_expected.to contain_python__pip('globus-cli').with('virtualenv' => '/opt/globus-cli')
      end

      it do
        is_expected.to contain_file('/usr/bin/globus').with('ensure' => 'link',
                                                            'target' => '/opt/globus-cli/bin/globus')
      end

      context 'manage_python => false' do
        let(:params) { { manage_python: false } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('python').without_virtualenv('present') }
      end
    end
  end
end
