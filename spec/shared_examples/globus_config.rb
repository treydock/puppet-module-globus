shared_examples_for 'globus::config' do |facts|
  it 'purges unmanaged configs' do
    is_expected.to contain_resources('globus_connect_config').with_purge('true')
  end

  it do
    is_expected.to contain_exec('globus-connect-server-setup').with(path: '/usr/bin:/bin:/usr/sbin:/sbin',
                                                                    command: 'globus-connect-server-io-setup && globus-connect-server-id-setup',
                                                                    refreshonly: 'true')
  end

  it do
    is_expected.to contain_file('/etc/globus-connect-server.conf').with(ensure: 'file',
                                                                        owner: 'root',
                                                                        group: 'root',
                                                                        mode: '0600')
  end

  it { is_expected.to contain_globus_connect_config('Globus/User').with_value('%(GLOBUS_USER)s').with_notify('Exec[globus-connect-server-setup]') }
  it { is_expected.to contain_globus_connect_config('Globus/Password').with_value('%(GLOBUS_PASSWORD)s').with_secret('true') }
  it { is_expected.to contain_globus_connect_config('Endpoint/Name').with_value(facts[:hostname]) }
  it { is_expected.to contain_globus_connect_config('Endpoint/Public').with_value('false') }
  it { is_expected.to contain_globus_connect_config('Endpoint/DefaultDirectory').with_value('/~/') }
  it { is_expected.to contain_globus_connect_config('Security/FetchCredentialFromRelay').with_value('true') }
  it { is_expected.to contain_globus_connect_config('Security/CertificateFile').with_value('/var/lib/globus-connect-server/grid-security/hostcert.pem') }
  it { is_expected.to contain_globus_connect_config('Security/KeyFile').with_value('/var/lib/globus-connect-server/grid-security/hostkey.pem') }
  it { is_expected.to contain_globus_connect_config('Security/TrustedCertificateDirectory').with_value('/var/lib/globus-connect-server/grid-security/certificates/') }
  it { is_expected.to contain_globus_connect_config('Security/IdentityMethod').with_value('MyProxy') }
  it { is_expected.not_to contain_globus_connect_config('Security/AuthorizationMethod') }
  it { is_expected.not_to contain_globus_connect_config('Security/Gridmap') }
  it { is_expected.not_to contain_globus_connect_config('Security/CILogonIdentityProvider') }
  it { is_expected.to contain_globus_connect_config('GridFTP/Server').with_value("#{facts[:fqdn]}:2811") }
  it { is_expected.to contain_globus_connect_config('GridFTP/ServerBehindNAT').with_value('false') }
  it { is_expected.to contain_globus_connect_config('GridFTP/IncomingPortRange').with_value('50000,51000') }
  it { is_expected.not_to contain_globus_connect_config('GridFTP/OutgoingPortRange') }
  it { is_expected.not_to contain_globus_connect_config('GridFTP/DataInterface') }
  it { is_expected.to contain_globus_connect_config('GridFTP/RestrictPaths').with_value('RW~,N~/.*') }
  it { is_expected.to contain_globus_connect_config('GridFTP/Sharing').with_value('false') }
  it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingRestrictPaths') }
  it { is_expected.to contain_globus_connect_config('GridFTP/SharingStateDir').with_value('$HOME/.globus/sharing') }
  it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingUsersAllow') }
  it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingGroupsAllow') }
  it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingUsersDeny') }
  it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingGroupsDeny') }
  it { is_expected.to contain_globus_connect_config('MyProxy/Server').with_value("#{facts[:fqdn]}:7512") }
  it { is_expected.to contain_globus_connect_config('MyProxy/ServerBehindNAT').with_value('false') }
  it { is_expected.to contain_globus_connect_config('MyProxy/CADirectory').with_value('/var/lib/globus-connect-server/myproxy-ca') }
  it { is_expected.to contain_globus_connect_config('MyProxy/ConfigFile').with_value('/var/lib/globus-connect-server/myproxy-server.conf') }
  it { is_expected.not_to contain_globus_connect_config('OAuth/Server') }
  it { is_expected.not_to contain_globus_connect_config('OAuth/ServerBehindNAT') }
  it { is_expected.not_to contain_globus_connect_config('OAuth/Stylesheet') }
  it { is_expected.not_to contain_globus_connect_config('OAuth/Logo') }

  it { is_expected.not_to contain_file('/etc/cron.hourly/globus-connect-server-cilogon-basic-crl') }
  it { is_expected.not_to contain_file('/etc/cron.hourly/globus-connect-server-cilogon-silver-crl') }
  it { is_expected.not_to contain_file('/etc/gridftp.d/z-extra-settings') }
  it { is_expected.not_to contain_exec('add-gridftp-callback') }

  it do
    is_expected.to contain_firewall('500 allow GridFTP control channel').with(action: 'accept',
                                                                              dport: '2811',
                                                                              proto: 'tcp')
  end

  it do
    is_expected.to contain_firewall('500 allow GridFTP data channels').with(action: 'accept',
                                                                            dport: '50000-51000',
                                                                            proto: 'tcp')
  end

  it do
    is_expected.to contain_firewall('500 allow MyProxy from 174.129.226.69').with(action: 'accept',
                                                                                  dport: '7512',
                                                                                  proto: 'tcp',
                                                                                  source: '174.129.226.69')
  end

  it do
    is_expected.to contain_firewall('500 allow MyProxy from 54.237.254.192/29').with(action: 'accept',
                                                                                     dport: '7512',
                                                                                     proto: 'tcp',
                                                                                     source: '54.237.254.192/29')
  end

  it do
    is_expected.not_to contain_firewall('500 allow OAuth HTTPS').with(action: 'accept',
                                                                      dport: '443',
                                                                      proto: 'tcp')
  end

  context 'when run_setup_commands => false' do
    let(:params) { { run_setup_commands: false } }

    it { is_expected.not_to contain_exec('globus-connect-server-setup') }
    it { is_expected.to contain_globus_connect_config('Globus/User').without_notify }
  end

  context 'when remove_cilogon_cron => true' do
    let(:params) { { remove_cilogon_cron: true } }

    it { is_expected.to contain_file('/etc/cron.hourly/globus-connect-server-cilogon-basic-crl').with_ensure('absent') }
    it { is_expected.to contain_file('/etc/cron.hourly/globus-connect-server-cilogon-silver-crl').with_ensure('absent') }
  end

  context 'when extra_gridftp_settings defined' do
    let(:params) do
      {
        extra_gridftp_settings: [
          'log_level ALL',
          'log_single /var/log/gridftp-auth.log',
          'log_transfer /var/log/gridftp.log',
          '$LLGT_LOG_IDENT "gridftp-server-llgt"',
          '$LCMAPS_DB_FILE "/etc/lcmaps.db"',
          '$LCMAPS_POLICY_NAME "authorize_only"',
          '$LLGT_LIFT_PRIVILEGED_PROTECTION "1"',
          '$LCMAPS_DEBUG_LEVEL "2"',
        ],
      }
    end

    it do
      is_expected.to contain_file('/etc/gridftp.d/z-extra-settings').with(ensure: 'file',
                                                                          owner: 'root',
                                                                          group: 'root',
                                                                          mode: '0644',
                                                                          notify: 'Service[globus-gridftp-server]')
    end

    it do
      verify_contents(catalogue, '/etc/gridftp.d/z-extra-settings', [
                        'log_level ALL',
                        'log_single /var/log/gridftp-auth.log',
                        'log_transfer /var/log/gridftp.log',
                        '$LLGT_LOG_IDENT "gridftp-server-llgt"',
                        '$LCMAPS_DB_FILE "/etc/lcmaps.db"',
                        '$LCMAPS_POLICY_NAME "authorize_only"',
                        '$LLGT_LIFT_PRIVILEGED_PROTECTION "1"',
                        '$LCMAPS_DEBUG_LEVEL "2"',
                      ])
    end
  end

  context 'when first_gridftp_callback defined' do
    let(:params) { { first_gridftp_callback: '|globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout' } }

    it do
      is_expected.to contain_exec('add-gridftp-callback')
        .with(path: '/usr/bin:/bin:/usr/sbin:/sbin',
              command: 'sed -i \'1s/^/|globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout\n/\' /var/lib/globus-connect-server/gsi-authz.conf',
              unless: 'head -n 1 /var/lib/globus-connect-server/gsi-authz.conf | egrep -q \'^\|globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout$\'',
              onlyif: 'test -f /var/lib/globus-connect-server/gsi-authz.conf',
              require: 'Exec[globus-connect-server-setup]',
              notify: 'Service[globus-gridftp-server]')
    end

    context 'when run_setup_commands => false' do
      let(:params) { { first_gridftp_callback: '|globus_mapping liblcas_lcmaps_gt4_mapping.so lcmaps_callout', run_setup_commands: false } }

      it { is_expected.to contain_exec('add-gridftp-callback').without_require }
    end
  end

  context 'when manage_firewall => false' do
    let(:params) { { manage_firewall: false } }

    it { is_expected.not_to contain_firewall('500 allow GridFTP control channel') }
    it { is_expected.not_to contain_firewall('500 allow GridFTP data channels') }
  end

  context 'version => 5', if: support_v5(facts) do
    let(:pre_condition) { "class { 'globus::params': version => '5' }" }

    # v5 configs
    it { is_expected.to contain_globus_connect_config('Globus/ClientId').with_value('').with_notify('Exec[globus-connect-server-setup]') }
    it { is_expected.to contain_globus_connect_config('Globus/ClientSecret').with_value('').with_secret('true') }
    it { is_expected.to contain_globus_connect_config('Endpoint/Name').with_value(facts[:hostname]) }
    it { is_expected.to contain_globus_connect_config('Endpoint/ServerName').with_value(facts[:fqdn]) }
    it { is_expected.to contain_globus_connect_config('LetsEncrypt/Email').with_value('') }
    it { is_expected.to contain_globus_connect_config('LetsEncrypt/AgreeToS').with_value('false') }
    it { is_expected.to contain_globus_connect_config('GridFTP/IncomingPortRange').with_value('50000,51000') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/OutgoingPortRange') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/DataInterface') }
    it { is_expected.to contain_globus_connect_config('GridFTP/RequireEncryption').with_value('false') }

    # v4 Configs
    it { is_expected.not_to contain_globus_connect_config('Globus/User') }
    it { is_expected.not_to contain_globus_connect_config('Globus/Password') }
    it { is_expected.not_to contain_globus_connect_config('Endpoint/Public') }
    it { is_expected.not_to contain_globus_connect_config('Endpoint/DefaultDirectory') }
    it { is_expected.not_to contain_globus_connect_config('Security/FetchCredentialFromRelay') }
    it { is_expected.not_to contain_globus_connect_config('Security/CertificateFile') }
    it { is_expected.not_to contain_globus_connect_config('Security/KeyFile') }
    it { is_expected.not_to contain_globus_connect_config('Security/TrustedCertificateDirectory') }
    it { is_expected.not_to contain_globus_connect_config('Security/IdentityMethod') }
    it { is_expected.not_to contain_globus_connect_config('Security/AuthorizationMethod') }
    it { is_expected.not_to contain_globus_connect_config('Security/Gridmap') }
    it { is_expected.not_to contain_globus_connect_config('Security/CILogonIdentityProvider') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/Server') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/ServerBehindNAT') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/RestrictPaths') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/Sharing') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingRestrictPaths') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingStateDir') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingUsersAllow') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingGroupsAllow') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingUsersDeny') }
    it { is_expected.not_to contain_globus_connect_config('GridFTP/SharingGroupsDeny') }
    it { is_expected.not_to contain_globus_connect_config('MyProxy/Server') }
    it { is_expected.not_to contain_globus_connect_config('MyProxy/ServerBehindNAT') }
    it { is_expected.not_to contain_globus_connect_config('MyProxy/CADirectory') }
    it { is_expected.not_to contain_globus_connect_config('MyProxy/ConfigFile') }
    it { is_expected.not_to contain_globus_connect_config('OAuth/Server') }
    it { is_expected.not_to contain_globus_connect_config('OAuth/ServerBehindNAT') }
    it { is_expected.not_to contain_globus_connect_config('OAuth/Stylesheet') }
    it { is_expected.not_to contain_globus_connect_config('OAuth/Logo') }
  end
end
