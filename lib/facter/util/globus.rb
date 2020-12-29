# Util class for Globus facts
class Facter::Util::Globus
  def self.info
    '/var/lib/globus-connect-server/info.json'
  end

  def self.info_exists?
    File.exist?(info)
  end

  def self.read_info
    return nil unless info_exists?
    File.read(info)
  end
end
