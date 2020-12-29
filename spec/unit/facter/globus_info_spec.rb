require 'spec_helper'
require 'facter/util/globus'

describe 'globus_info Fact' do
  before :each do
    Facter.clear
    allow(Facter.fact(:kernel)).to receive(:value).and_return('Linux')
  end

  it 'returns Globus info' do
    allow(Facter::Util::Globus).to receive(:read_info).and_return(my_fixture_read('info.json'))
    value = Facter.fact(:globus_info).value
    expect(value).not_to be_nil
    expect(value['domain_name']).to eq('example0001.data.globus.org')
    expect(value['endpoint_id']).to eq('1c6b6e6a-3791-4213-b3e6-00001')
  end

  it 'returns nil if info.json does not exist' do
    allow(Facter::Util::Globus).to receive(:read_info).and_return(nil)
    expect(Facter.fact(:globus_info).value).to be_nil
  end

  it 'returns nil if info.json is invalid' do
    allow(Facter::Util::Globus).to receive(:read_info).and_return('[')
    expect(Facter.fact(:globus_info).value).to be_nil
  end
end
