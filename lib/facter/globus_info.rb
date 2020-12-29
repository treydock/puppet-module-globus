require 'json'
require 'facter/util/globus'

Facter.add('globus_info') do
  confine kernel: 'Linux'

  setcode do
    value = nil
    f = Facter::Util::Globus.read_info
    unless f.nil?
      begin
        value = JSON.parse(f)
      rescue JSON::ParserError
        value = nil
      end
    end
    value
  end
end
