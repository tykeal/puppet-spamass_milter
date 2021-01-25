# @summary Manages the spamass-milter or spamass-milter-root service
#
# Automatically chooses the correct service to run depending on the configured
# options
#
# @param ensure
#   Ensures the service at the defined level, unless enable is set to
#   'manual' or 'mask' at which point the module will stop ensuring running
#   or stopped status
# @param enable
#   Configure the service to automatically start on system start
#   true, service starts on system start
#   false, service does not start on system start (puppet will then ensure it
#   during it's first run to whatever the ensure value is
#   manual, service will not be managed by puppet other than the enable value
#   mask, service will not be managed by puppet other than the enable value
# @param expand_user
#   Configuration flag to determine which service should be used. This should
#   follow spamass_milter::config::expand_user !
class spamass_milter::service (
  Stdlib::Ensure::Service $ensure,
  Variant[Boolean, Enum['manual', 'mask']] $enable,
  Boolean $expand_user,
) {
  # if $enable is not a boolean, we don't actually know what the ensure should
  # be
  if is_bool($enable) {
    $_ensure = $ensure
  } else {
    $_ensure = undef
  }

  if $expand_user {
    service { 'spamass-milter':
      ensure     => 'stopped',
      enable     => false,
      hasrestart => true,
      hasstatus  => true,
    }

    service { 'spamass-milter-root':
      ensure     => $_ensure,
      enable     => $enable,
      hasrestart => true,
      hasstatus  => true,
    }
  } else {
    service { 'spamass-milter':
      ensure     => $_ensure,
      enable     => $enable,
      hasrestart => true,
      hasstatus  => true,
    }

    service { 'spamass-milter-root':
      ensure     => 'stopped',
      enable     => false,
      hasrestart => true,
      hasstatus  => true,
    }
  }
}
