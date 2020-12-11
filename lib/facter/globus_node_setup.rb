Facter.add('globus_node_setup') do
  confine :kernel => 'Linux'

  setcode do
    File.exists?('/var/lib/globus-connect-server/info.json')
  end
end
