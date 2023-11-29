# @summary Manage Globus
#
# @example Install and setup a Globus v5.4 endpoint
#   class { 'globus':
#     display_name  => 'REPLACE My Site Globus',
#     owner         => 'REPLACE-user@example.com',
#   }
#
# @param release_url
#   Release URL of Globus release RPM
# @param gcs_repo_baseurl
#   Globus Connect Server repo baseurl
# @param gcs_repo_testing_baseurl
#   Globus testing repo baseurl
# @param enable_testing_repos
#   Boolean that sets if testing repos should be added
# @param extra_gridftp_settings
#   Additional settings for GridFTP
# @param manage_service
#   Boolean to set if globus-gridftp-server service is managed
# @param run_setup_commands
#   Boolean to set if the commands to setup Globus are run (v4 and v5)
# @param manage_firewall
#   Boolean to set if firewall rules are managed by this module
# @param manage_epel
#   Boolean to set if EPEL is managed by this repo
# @param manage_user
#   Boolean to set if the gcsweb user and group are managed by this module
# @param group_gid
#   The gcsweb group GID
# @param user_uid
#   The gcsweb user UID
# @param package_name
#   Globus package name
# @param display_name
#   Display name to use when running 'globus-connect-server endpoint setup'
# @param project_id
#   --project-id use when running 'globus-connect-server endpoint setup'
# @param project_admin
#   --project-admin use when running 'globus-connect-server endpoint setup'
# @param owner
#   --owner use when running 'globus-connect-server endpoint setup'
# @param organization
#   --organization use when running 'globus-connect-server endpoint setup'
# @param deployment_key
#   --deployment-key use when running 'globus-connect-server endpoint setup'
#   The parent directory of this path must be writable by gcsweb user
# @param keywords
#   --keywords use when running 'globus-connect-server endpoint setup'
# @param department
#   --department use when running 'globus-connect-server endpoint setup'
# @param contact_email
#   --contact-email use when running 'globus-connect-server endpoint setup'
# @param contact_info
#   --contact-info use when running 'globus-connect-server endpoint setup'
# @param info_link
#   --info-link use when running 'globus-connect-server endpoint setup'
# @param description
#   --description use when running 'globus-connect-server endpoint setup'
# @param public
#   When false pass --private flag to 'globus-connect-server endpoint setup'
# @param incoming_port_range
#   --incoming-port-range use when running 'globus-connect-server node setup'
# @param outgoing_port_range
#   --outgoing-port-range use when running 'globus-connect-server node setup'
# @param ip_address
#   --ip-address use when running 'globus-connect-server node setup'
# @param export_node
#   --export-node use when running 'globus-connect-server node setup'
# @param import_node
#   --import-node use when running 'globus-connect-server node setup'
#
class globus (
  # Required
  String[1] $display_name,
  String[1] $owner,
  String[1] $organization,

  Variant[Stdlib::Httpsurl, Stdlib::Httpurl] $release_url = 'https://downloads.globus.org/toolkit/globus-connect-server/globus-connect-server-repo-latest.noarch.rpm',
  Variant[Stdlib::Httpsurl, Stdlib::Httpurl] $gcs_repo_baseurl = "https://downloads.globus.org/globus-connect-server/stable/rpm/el/${facts['os']['release']['major']}/\$basearch/",
  Variant[Stdlib::Httpsurl, Stdlib::Httpurl] $gcs_repo_testing_baseurl = "https://downloads.globus.org/globus-connect-server/testing/rpm/el/${facts['os']['release']['major']}/\$basearch/",
  Boolean $enable_testing_repos = false,
  Array $extra_gridftp_settings = [],
  Boolean $manage_service = true,
  Boolean $run_setup_commands = true,
  Boolean $manage_firewall = true,
  Boolean $manage_epel = true,

  Boolean $manage_user = true,
  Optional[Integer] $group_gid = undef,
  Optional[Integer] $user_uid = undef,
  String $package_name = 'globus-connect-server54',
  Stdlib::Absolutepath $deployment_key = '/var/lib/globus-connect-server/gcs-manager/deployment-key.json',

  # endpoint setup
  Optional[String[1]] $project_id = undef,
  Optional[String[1]] $project_admin = undef,
  Optional[Array] $keywords = undef,
  Optional[String] $department = undef,
  Optional[String] $contact_email = undef,
  Optional[String] $contact_info = undef,
  Optional[String] $info_link = undef,
  Optional[String] $description = undef,
  Boolean $public = true,
  # node setup
  Array[Stdlib::Port, 2, 2] $incoming_port_range = [50000, 51000],
  Optional[Array[Stdlib::Port, 2, 2]] $outgoing_port_range = undef,
  Optional[Stdlib::IP::Address] $ip_address = undef,
  Optional[Stdlib::Absolutepath] $export_node = undef,
  Optional[Stdlib::Absolutepath] $import_node = undef,
) {
  $osfamily = $facts.dig('os', 'family')

  if ! $ip_address {
    $_ip_address = $facts.dig('networking','ip')
  } else {
    $_ip_address = $ip_address
  }

  if $manage_service {
    $notify_service = Service['globus-gridftp-server']
  } else {
    $notify_service = undef
  }

  contain globus::user
  contain globus::install
  contain globus::config
  contain globus::service

  Class['globus::user']
  -> Class['globus::install']
  -> Class['globus::config']
  -> Class['globus::service']

  case $osfamily {
    'RedHat': {
      if $manage_epel {
        include epel
        Class['epel'] -> Class['globus::repo::el']
      }
      contain globus::repo::el

      Class['globus::repo::el'] -> Class['globus::install']
    }
    'Debian': {
      contain globus::repo::deb

      Class['globus::repo::deb'] -> Class['globus::install']
    }
    default: {
      # Do nothing
    }
  }
}
