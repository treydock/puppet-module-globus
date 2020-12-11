require 'spec_helper'

describe 'globus::cli' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:platform_os) { "#{facts[:os]['family']}-#{facts[:os]['release']['major']}" }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('globus::cli') }

      it do
        is_expected.to contain_class('python').with(
          version: platforms[platform_os][:python_version],
          virtualenv: 'present',
        )
      end

      it do
        is_expected.to contain_python__virtualenv('globus-cli').with(
          'ensure'     => 'present',
          'version'    => platforms[platform_os][:python_version],
          'virtualenv' => platforms[platform_os][:virtualenv_provider],
          'venv_dir'   => '/opt/globus-cli',
          'distribute' => 'false',
        )
      end

      it do
        is_expected.to contain_python__pip('globus-cli').with(
          'ensure'        => 'present',
          'pip_provider'  => platforms[platform_os][:pip_provider],
          'virtualenv'    => '/opt/globus-cli',
        )
      end

      it do
        is_expected.to contain_file('/usr/bin/globus').with('ensure' => 'link',
                                                            'target' => '/opt/globus-cli/bin/globus')
      end
    end
  end
end
