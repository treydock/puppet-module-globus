require 'facter/util/globus'

Facter.add('globus_node_setup') do
  confine kernel: 'Linux'

  setcode do
    Facter::Util::Globus.info_exists?
  end
end
