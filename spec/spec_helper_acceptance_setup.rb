# frozen_string_literal: true

RSpec.configure do |c|
  c.before(:suite) do
    on hosts, 'mkdir -p /opt/puppetlabs/puppet/cache/lib/facter/'
    if ['debian-12', 'ubuntu-2404'].include?(ENV['BEAKER_set'])
      on hosts, 'cp /etc/puppet/code/modules/python/lib/facter/* /opt/puppetlabs/puppet/cache/lib/facter/'
    else
      on hosts, 'cp /etc/puppetlabs/code/environments/production/modules/python/lib/facter/* /opt/puppetlabs/puppet/cache/lib/facter/'
    end
  end
end
