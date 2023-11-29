# frozen_string_literal: true

Puppet::Functions.create_function(:'globus::endpoint_setup_args') do
  dispatch :args do
    param 'Hash', :values
  end
  def args(values)
    flags = []
    flags << "'#{values['display_name']}'"
    flags << "--owner '#{values['owner']}'"
    flags << "--project-id '#{values['project_id']}" unless values['project_id'].nil?
    flags << "--project-admin '#{values['project_admin']}" unless values['project_admin'].nil?
    flags << "--organization '#{values['organization']}'"
    flags << "--deployment-key #{values['deployment_key']}"
    flags << '--agree-to-letsencrypt-tos'
    flags << "--keywords '#{values['keywords'].join(',')}'" unless values['keywords'].nil?
    flags << "--department '#{values['department']}'" unless values['department'].nil?
    flags << "--contact-email '#{values['contact_email']}'" unless values['contact_email'].nil?
    flags << "--contact-info '#{values['contact_info']}'" unless values['contact_info'].nil?
    flags << "--info-link '#{values['info_link']}'" unless values['info_link'].nil?
    flags << "--description '#{values['description']}'" unless values['description'].nil?
    flags << '--private' unless values['public']
    flags.join(' ')
  end
end
