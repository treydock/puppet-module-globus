# frozen_string_literal: true

require 'spec_helper'

describe 'globus' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) do
        os_facts
      end

      let(:default_params) do
        {
          client_id: 'foo',
          client_secret: 'bar',
          owner: 'admin@example.com',
          display_name: 'Example',
          organization: 'Example'
        }
      end
      let(:params) { default_params }

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('globus') }

      if os_facts[:os]['family'] == 'RedHat'
        it { is_expected.to contain_class('epel').that_comes_before('Class[globus::repo::el]') }
        it { is_expected.to contain_class('globus::repo::el').that_comes_before('Class[globus::install]') }
      end
      if os_facts[:os]['family'] == 'Debian'
        it { is_expected.to contain_class('globus::repo::deb').that_comes_before('Class[globus::install]') }
      end
      it { is_expected.to contain_class('globus::user').that_comes_before('Class[globus::install]') }
      it { is_expected.to contain_class('globus::install').that_comes_before('Class[globus::config]') }
      it { is_expected.to contain_class('globus::config').that_comes_before('Class[globus::service]') }
      it { is_expected.to contain_class('globus::service') }

      context 'when version => 5' do
        let(:params) { default_params }

        if os_facts[:os]['family'] == 'RedHat'
          it_behaves_like 'globus::repo::el', os_facts
        end
        if os_facts[:os]['family'] == 'Debian'
          it { is_expected.not_to contain_class('epel') }

          it_behaves_like 'globus::repo::deb', os_facts
        end
        it_behaves_like 'globus::user', os_facts
        it_behaves_like 'globus::install', os_facts
        it_behaves_like 'globus::config', os_facts
        it_behaves_like 'globus::service', os_facts
      end

      context 'when manage_epel => false' do
        let(:params) { default_params.merge(manage_epel: false) }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('epel') }
      end

      context 'when version => 4', if: support_v4(os_facts) do
        let(:default_params) { { version: '4' } }
        let(:params) { default_params }

        it { is_expected.to compile.with_all_deps }

        it { is_expected.not_to contain_group('gcsweb') }
        it { is_expected.not_to contain_user('gcsweb') }

        if os_facts[:os]['family'] == 'RedHat'
          it_behaves_like 'globus::repo::elv4', os_facts
        end
        if os_facts[:os]['family'] == 'Debian'
          it { is_expected.not_to contain_class('epel') }

          it_behaves_like 'globus::repo::debv4', os_facts
        end
        it_behaves_like 'globus::installv4', os_facts
        it_behaves_like 'globus::configv4', os_facts
        it_behaves_like 'globus::servicev4', os_facts
      end
    end
  end
end
