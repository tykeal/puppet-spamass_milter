# @summary Install spamass-milter
#
# Installs spamass-milter using the defined package
#
# @param ensure
#   If true, will ensure the package as stated (default: installed)
#   NOTE: the default makes sure it is installed, but will not upgrade
#   unless changed to latest!
# @param manage_package
#   If true, will ensure the spamass-milter package (default: true)
# @param package_name
#   The name of the package to install (default: spamass-milter)
# @param postfix_extension
#   If true also install postfix extension package (default: true)
# @param postfix_extension_package
#   The name of the postfix extension package to install (default:
#   spamass-milter-postfix)
class spamass_milter::install (
  Enum['present', 'absent', 'installed', 'latest'] $ensure,
  Boolean $manage_package,
  String $package_name,
  Boolean $postfix_extension,
  String $postfix_extension_package,
) {
  if ($manage_package) {
    package { $package_name:
      ensure => $ensure
    }

    if ($postfix_extension) {
      package { $postfix_extension_package:
        ensure => $ensure
      }
    }
  }
}
