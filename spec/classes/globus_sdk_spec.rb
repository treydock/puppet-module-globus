# frozen_string_literal: true

require 'spec_helper'

describe 'globus::sdk' do
  on_supported_os.each do |os, facts|
    context "when #{os}" do
      let(:facts) do
        facts
      end
      let(:platform_os) { "#{facts[:os]['family']}-#{facts[:os]['release']['major']}" }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('globus::sdk') }

      it do
        is_expected.to contain_class('python').with(
          version: platforms[platform_os][:python_version],
          dev: 'present',
        )
      end

      it do
        is_expected.to contain_python__pyvenv('globus-sdk').with(
          'ensure' => 'present',
          'version' => platforms[platform_os][:venv_python_version],
          'venv_dir' => '/opt/globus-sdk',
          'systempkgs' => 'true',
        )
      end

      it { is_expected.to contain_python__pyvenv('globus-sdk').that_comes_before('Python::Pip[globus-sdk]') }

      it do
        is_expected.to contain_python__pip('globus-sdk').with(
          'ensure' => 'present',
          'pip_provider' => platforms[platform_os][:pip_provider],
          'virtualenv' => '/opt/globus-sdk',
        )
      end
    end
  end
end
