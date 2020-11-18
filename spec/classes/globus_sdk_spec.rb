require 'spec_helper'

describe 'globus::sdk' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      unless support_sdk(facts)
        skip('SDK not supported')
        next
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('globus::sdk') }

      it { is_expected.to contain_class('python').with_virtualenv('present') }

      it do
        is_expected.to contain_python__virtualenv('globus-sdk').with(
          'ensure'     => 'present',
          'venv_dir'   => '/opt/globus-sdk',
          'distribute' => 'false',
        )
      end

      it do
        is_expected.to contain_python__pip('globus-sdk').with(
          'ensure'     => 'present',
          'virtualenv' => '/opt/globus-sdk',
        )
      end

      context 'manage_python => false' do
        let(:params) { { manage_python: false } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.to contain_class('python').without_virtualenv('present') }
      end
    end
  end
end
