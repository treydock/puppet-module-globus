# frozen_string_literal: true

require 'json'
require 'facter/util/globus'

Facter.add('globus_info') do
  confine kernel: 'Linux'

  setcode do
    info = Facter::Util::Globus.read_info
    info
  end
end
