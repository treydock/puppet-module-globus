# frozen_string_literal: true

RSpec.configure do |c|
  c.before(:suite) do
    on hosts, 'mkdir -p /opt/puppetlabs/puppet/cache/lib/facter/'
    on hosts, 'cp /etc/puppetlabs/code/environments/production/modules/python/lib/facter/* /opt/puppetlabs/puppet/cache/lib/facter/'
  end
end
