require 'puppet'
require 'puppet/type/globus_connect_config'

describe 'Puppet::Type.type(:globus_connect_config)' do
  let(:globus_connect_config) do
    Puppet::Type.type(:globus_connect_config).new(name: 'vars/foo', value: 'bar')
  end

  it 'requires a name' do
    expect {
      Puppet::Type.type(:globus_connect_config).new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end

  it 'does not expect a name with whitespace' do
    expect {
      Puppet::Type.type(:globus_connect_config).new(name: 'f oo')
    }.to raise_error(Puppet::Error, %r{Invalid globus_connect_config})
  end

  it 'fails when there is no section' do
    expect {
      Puppet::Type.type(:globus_connect_config).new(name: 'foo')
    }.to raise_error(Puppet::Error, %r{Invalid globus_connect_config})
  end

  it 'does not require a value when ensure is absent' do
    Puppet::Type.type(:globus_connect_config).new(name: 'vars/foo', ensure: :absent)
  end

  it 'requires a value when ensure is present' do
    expect {
      Puppet::Type.type(:globus_connect_config).new(name: 'vars/foo', ensure: :present)
    }.to raise_error(Puppet::Error, %r{Property value must be set})
  end

  it 'accepts a valid value' do
    globus_connect_config[:value] = 'bar'
    expect(globus_connect_config[:value]).to eq('bar')
  end

  it 'does not accept a value with whitespace' do
    globus_connect_config[:value] = 'b ar'
    expect(globus_connect_config[:value]).to eq('b ar')
  end

  it 'accepts valid ensure values' do
    globus_connect_config[:ensure] = :present
    expect(globus_connect_config[:ensure]).to eq(:present)
    globus_connect_config[:ensure] = :absent
    expect(globus_connect_config[:ensure]).to eq(:absent)
  end

  it 'does not accept invalid ensure values' do
    expect {
      globus_connect_config[:ensure] = :latest
    }.to raise_error(Puppet::Error, %r{Invalid value})
  end

  it 'capitalizes true value' do
    globus_connect_config[:value] = true
    expect(globus_connect_config[:value]).to eq('True')
    globus_connect_config[:value] = 'true'
    expect(globus_connect_config[:value]).to eq('True')
  end

  it 'capitalizes false value' do
    globus_connect_config[:value] = false
    expect(globus_connect_config[:value]).to eq('False')
    globus_connect_config[:value] = 'false'
    expect(globus_connect_config[:value]).to eq('False')
  end

  describe 'autorequire File resources' do
    it 'autorequires /etc/globus-connect-server.conf' do
      conf = Puppet::Type.type(:file).new(name: '/etc/globus-connect-server.conf')
      catalog = Puppet::Resource::Catalog.new
      catalog.add_resource globus_connect_config
      catalog.add_resource conf
      rel = globus_connect_config.autorequire[0]
      expect(rel.source.ref).to eq(conf.ref)
      expect(rel.target.ref).to eq(globus_connect_config.ref)
    end
  end
end
