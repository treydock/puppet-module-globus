# frozen_string_literal: true

require 'facter/util/globus'

Facter.add('globus_node_setup') do
  confine kernel: 'Linux'

  setcode do
    info = Facter::Util::Globus.read_info
    !info.nil?
  end
end
