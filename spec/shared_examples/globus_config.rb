shared_examples_for 'globus::config' do |_facts|
  let(:endpoint_setup) do
    [
      'globus-connect-server endpoint setup',
      "'Example' --client-id foo",
      "--owner 'admin@example.com'",
      '--deployment-key /var/lib/globus-connect-server/gcs-manager/deployment-key.json',
    ]
  end
  let(:node_setup) do
    [
      'globus-connect-server node setup',
      '--client-id foo',
      '--deployment-key /var/lib/globus-connect-server/gcs-manager/deployment-key.json',
      '--incoming-port-range 50000,51000',
      '--ip-address 172.16.254.254',
    ]
  end

  it do
    is_expected.to contain_file('/root/globus-endpoint-setup').with(
      ensure: 'file',
      owner: 'root',
      group: 'root',
      mode: '0700',
      show_diff: 'false',
      content: "export GLOBUS_CLIENT_SECRET=bar
#{endpoint_setup.join(' ')}
",
    )
  end

  it do
    is_expected.to contain_file('/root/globus-node-setup').with(
      ensure: 'file',
      owner: 'root',
      group: 'root',
      mode: '0700',
      show_diff: 'false',
      content: "export GLOBUS_CLIENT_SECRET=bar
#{node_setup.join(' ')}
",
    )
  end

  it 'has endpoint setup command' do
    is_expected.to contain_exec('globus-endpoint-setup').with(
      path: '/usr/bin:/bin:/usr/sbin:/sbin',
      command: endpoint_setup.join(' '),
      environment: ['GLOBUS_CLIENT_SECRET=bar'],
      creates: '/var/lib/globus-connect-server/gcs-manager/deployment-key.json',
      logoutput: 'true',
    )
  end

  it 'has node setup command' do
    is_expected.to contain_exec('globus-node-setup').with(
      path: '/usr/bin:/bin:/usr/sbin:/sbin',
      command: node_setup.join(' '),
      environment: ['GLOBUS_CLIENT_SECRET=bar'],
      creates: '/var/lib/globus-connect-server/info.json',
      logoutput: 'true',
      require: 'Exec[globus-endpoint-setup]',
    )
  end

  it do
    is_expected.to contain_firewall('500 allow HTTPS').with(
      action: 'accept',
      dport: '443',
      proto: 'tcp',
    )
  end

  it do
    is_expected.to contain_firewall('500 allow GridFTP data channels').with(
      action: 'accept',
      dport: '50000-51000',
      proto: 'tcp',
    )
  end

  it { is_expected.not_to contain_firewall('500 allow GridFTP control channel') }

  context 'when run_setup_commands => false' do
    let(:params) { default_params.merge(run_setup_commands: false) }

    it { is_expected.not_to contain_exec('globus-endpoint-setup') }
    it { is_expected.not_to contain_exec('globus-node-setup') }
  end

  context 'when extra_gridftp_settings defined' do
    let(:params) do
      default_params.merge(extra_gridftp_settings: [
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

  context 'when manage_firewall => false' do
    let(:params) { default_params.merge(manage_firewall: false) }

    it { is_expected.not_to contain_firewall('500 allow GridFTP control channel') }
    it { is_expected.not_to contain_firewall('500 allow GridFTP data channels') }
    it { is_expected.not_to contain_firewall('500 allow HTTPS') }
  end
end
