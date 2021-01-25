# @summary Install and configure spamass-milter
#
# Installs and configures spamass-milter
#
# @example
#   include spamass_milter
class spamass_milter {
  include spamass_milter::install
  include spamass_milter::config
  include spamass_milter::service

  # Setup proper class ordering
  Class['spamass_milter::install']
  -> Class['spamass_milter::config']
  ~> Class['spamass_milter::service']
}
