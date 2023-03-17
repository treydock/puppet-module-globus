# frozen_string_literal: true

Puppet::Functions.create_function(:'globus::node_setup_args') do
  dispatch :args do
    param 'Hash', :values
  end
  def args(values)
    flags = []
    flags << "--client-id #{values['client_id']}"
    flags << "--deployment-key #{values['deployment_key']}"
    flags << "--incoming-port-range #{values['incoming_port_range'].join(' ')}" unless values['incoming_port_range'].nil?
    flags << "--outgoing-port-range #{values['outgoing_port_range'].join(' ')}" unless values['outgoing_port_range'].nil?
    flags << "--ip-address #{values['ip_address']}" unless values['ip_address'].nil?
    flags << "--export-node #{values['export_node']}" unless values['export_node'].nil?
    flags << "--import-node #{values['import_node']}" unless values['import_node'].nil?
    flags.join(' ')
  end
end
