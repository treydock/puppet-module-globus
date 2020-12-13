require 'spec_helper'

describe 'globus' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      let(:default_params) do
        {
          client_id: 'foo',
          client_secret: 'bar',
          owner: 'admin@example.com',
          display_name: 'Example',
        }
      end
      let(:params) { default_params }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('globus') }

      if facts[:os]['family'] == 'RedHat'
        it { is_expected.to contain_class('epel').that_comes_before('Class[globus::repo::el]') }
        it { is_expected.to contain_class('globus::repo::el').that_comes_before('Class[globus::install]') }
      end
      if facts[:os]['family'] == 'Debian'
        it { is_expected.to contain_class('globus::repo::deb').that_comes_before('Class[globus::install]') }
      end
      it { is_expected.to contain_class('globus::user').that_comes_before('Class[globus::install]') }
      it { is_expected.to contain_class('globus::install').that_comes_before('Class[globus::config]') }
      it { is_expected.to contain_class('globus::config').that_comes_before('Class[globus::service]') }
      it { is_expected.to contain_class('globus::service') }

      context 'version => 5' do
        let(:params) { default_params }

        if facts[:os]['family'] == 'RedHat'
          it_behaves_like 'globus::repo::el', facts
        end
        if facts[:os]['family'] == 'Debian'
          it { is_expected.not_to contain_class('epel') }
          it_behaves_like 'globus::repo::deb', facts
        end
        it_behaves_like 'globus::user', facts
        it_behaves_like 'globus::install', facts
        it_behaves_like 'globus::config', facts
        it_behaves_like 'globus::service', facts
      end

      context 'manage_epel => false' do
        let(:params) { default_params.merge(manage_epel: false) }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('epel') }
      end

      context 'version => 4', if: support_v4(facts) do
        let(:default_params) { { version: '4' } }
        let(:params) { default_params }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.not_to contain_group('gcsweb') }
        it { is_expected.not_to contain_user('gcsweb') }

        if facts[:os]['family'] == 'RedHat'
          it_behaves_like 'globus::repo::elv4', facts
        end
        if facts[:os]['family'] == 'Debian'
          it { is_expected.not_to contain_class('epel') }
          it_behaves_like 'globus::repo::debv4', facts
        end
        it_behaves_like 'globus::installv4', facts
        it_behaves_like 'globus::configv4', facts
        it_behaves_like 'globus::servicev4', facts
      end
    end
  end
end
