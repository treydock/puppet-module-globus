require 'spec_helper'

describe 'globus_node_setup Fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  it 'returns true if info.json exists' do
    allow(File).to receive(:exists?).with('/var/lib/globus-connect-server/info.json').and_return(true)
    expect(Facter.fact(:globus_node_setup).value).to eq(true)
  end

  it 'returns false if info.json does not exist' do
    allow(File).to receive(:exists?).with('/var/lib/globus-connect-server/info.json').and_return(false)
    expect(Facter.fact(:globus_node_setup).value).to eq(false)
  end
end
