require 'spec_helper'

describe 'globus' do
  on_supported_os.each do |os, facts|
    context "on #{os}" do
      let(:facts) do
        facts
      end

      it { is_expected.to compile.with_all_deps }

      it { is_expected.to create_class('globus') }

      it { is_expected.to contain_class('epel').that_comes_before('Class[globus::repo::el]') }
      it { is_expected.to contain_class('globus::repo::el').that_comes_before('Class[globus::install]') }
      it { is_expected.to contain_class('globus::install').that_comes_before('Class[globus::config]') }
      it { is_expected.to contain_class('globus::config').that_comes_before('Class[globus::service]') }
      it { is_expected.to contain_class('globus::service') }

      it_behaves_like 'globus::repo::el', facts
      it_behaves_like 'globus::install', facts
      it_behaves_like 'globus::config', facts
      it_behaves_like 'globus::service', facts

      context 'manage_epel => false' do
        let(:params) { { manage_epel: false } }

        it { is_expected.to compile.with_all_deps }
        it { is_expected.not_to contain_class('epel') }
      end

      context 'version => 5', if: support_v5(facts) do
        let(:params) { { version: '5' } }

        it { is_expected.to compile.with_all_deps }
      end
    end
  end
end
