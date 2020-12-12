require 'spec_helper'

describe 'globus::sdk' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end
      let(:platform_os) { "#{facts[:os]['family']}-#{facts[:os]['release']['major']}" }

      if facts[:os]['name'] == 'Ubuntu' && facts[:os]['release']['major'] == '20.04'
        before(:each) { skip('Unsupported OS') }
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('globus::sdk') }

      it do
        is_expected.to contain_class('python').with(
          version: platforms[platform_os][:python_version],
          virtualenv: 'present',
        )
      end

      if facts[:os]['family'] == 'RedHat'
        it do
          is_expected.to contain_python__virtualenv('globus-sdk').with(
            'ensure'     => 'present',
            'version'    => platforms[platform_os][:python_version],
            'virtualenv' => platforms[platform_os][:virtualenv_provider],
            'venv_dir'   => '/opt/globus-sdk',
            'distribute' => 'false',
          )
        end
        it { is_expected.to contain_python__virtualenv('globus-sdk').that_comes_before('Python::Pip[globus-sdk]') }
        it { is_expected.to contain_python__virtualenv('globus-sdk').that_requires('Package[virtualenv]') }
      end
      if facts[:os]['family'] == 'Debian'
        it do
          is_expected.to contain_python__pyvenv('globus-sdk').with(
            'ensure'     => 'present',
            'version'    => platforms[platform_os][:python_version],
            'venv_dir'   => '/opt/globus-sdk',
          )
        end
        it { is_expected.to contain_python__pyvenv('globus-sdk').that_comes_before('Python::Pip[globus-sdk]') }
        it { is_expected.to contain_python__pyvenv('globus-sdk').that_requires('Package[virtualenv]') }
      end

      it do
        is_expected.to contain_python__pip('globus-sdk').with(
          'ensure'        => 'present',
          'pip_provider'  => platforms[platform_os][:pip_provider],
          'virtualenv'    => '/opt/globus-sdk',
        )
      end
    end
  end
end
