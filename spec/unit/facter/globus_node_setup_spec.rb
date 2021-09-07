require 'spec_helper'
require 'facter/util/globus'

describe 'globus_node_setup Fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  it 'returns true if info.json exists' do
    allow(Facter::Util::Globus).to receive(:read_info).and_return(JSON.parse(my_fixture_read('info.json')))
    expect(Facter.fact(:globus_node_setup).value).to eq(true)
  end

  it 'returns false if info.json does not exist' do
    allow(Facter::Util::Globus).to receive(:read_info).and_return(nil)
    expect(Facter.fact(:globus_node_setup).value).to eq(false)
  end
end
