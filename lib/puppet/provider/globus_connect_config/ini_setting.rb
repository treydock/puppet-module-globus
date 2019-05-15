Puppet::Type.type(:globus_connect_config).provide(
  :ini_setting,
  parent: Puppet::Type.type(:ini_setting).provider(:ruby),
) do
  desc 'Provider globus_connect_config using ini_setting'

  def section
    resource[:name].split('/', 2)[0]
  end

  def setting
    resource[:name].split('/', 2)[1]
  end

  def separator
    ' = '
  end

  def self.file_path
    '/etc/globus-connect-server.conf'
  end
end
