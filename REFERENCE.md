# Reference

<!-- DO NOT EDIT: This document was generated by Puppet Strings -->

## Table of Contents

### Classes

-   [`spamass_milter`](#spamass_milter): Install and configure spamass-milter
-   [`spamass_milter::config`](#spamass_milterconfig): Configure spamass-milter
-   [`spamass_milter::install`](#spamass_milterinstall): Install spamass-milter
-   [`spamass_milter::service`](#spamass_milterservice): Manages the spamass-milter or spamass-milter-root service

## Classes

### `spamass_milter`

Installs and configures spamass-milter

#### Examples

#####

```puppet
include spamass_milter
```

### `spamass_milter::config`

Configures the /etc/sysconfig/spamass-milter file based upon hiera data

#param no_modify_subject
If set then spamass-milter will pass -m to disable the modification of
'Subject:' and 'Content-Type:' headers as well as the message body
(default: false, recommend true with option rejectscore set)

#### Parameters

The following parameters are available in the `spamass_milter::config` class.

##### `expand_user`

Data type: `Boolean`

If set then spamass-milter will pass -x and perform virtusertable and alias
expansion. This requires setting the -u setting which is done via
options[default_account][defaultuser] (default false)
NOTE: using this setting will cause spamass-milter to run as root instead
of the less privileged sa-milter

##### `no_modify_headers`

Data type: `Boolean`

If set then spamass-milter will pass -M to disable the 'X-Spam-\*' headers
(default: false)

##### `socket`

Data type: `Variant[
    Struct[{
      path => Stdlib::Unixpath,
    }],
    Struct[{
      port => Stdlib::Port,
      host => Stdlib::Host,
    }]]`

Takes one of two hash definitions:
{ path => Stdlib::Unixpath } which is a path to socket created for
commuication with spamassin
Or
{ port => Stdlib::Port, host => Stdlib::Host } which will create
an inet socket for communication
( default: port: 8895, host: 127.0.0.1 which is different from the EPEL
configuration of /run/spamass-milter/spamass-milter.sock)

##### `postfix_extension`

Data type: `Boolean`

Is the postfix extension being configured as well
(defaults to whatever spamass_milter::install::install_postfix_extension is)

##### `options`

Data type: `Optional[Struct[{
    debug           => Optional[Array[
      Variant[
        Enum['func', 'misc', 'net', 'poll', 'rcpt', 'spamc', 'str', 'uori'],
        Integer[1, 3],
    ]]],
    default_account => Optional[Struct[{
      defaultdomain => String,
      defaultuser   => String,
    }]],
    ignore          => Optional[Array[Stdlib::IP::Address]],
    rejectcode      => Optional[String],
    rejectscore     => Optional[Integer],
    rejecttext      => Optional[String],
    sendmailpath    => Optional[Stdlib::Unixpath],
    spamaddress     => Optional[Struct[{
      address           => Pattern[/\A([\w+\-].?)+@[a-z\d\-]+(\.[a-z]+)*\.[a-z]+\z/],
      retain_recipients => Boolean,
    }]],
    spamcflags      => Optional[String],
  }]]`

Options structure for all supported flags and configuration
debug: Configures the debug flags
Valid options are:
func, misc, net, poll, rcpt, spamc, str, uori, 1, 2, 3
default_account: Configures the default user and default domain options
NOTE: Per the design of this module, if one is to be set, then both must
be set
ignore: An array of Stdlib::IP::Address objects that will be configured for
ignoring by spamass-milter
rejectcode: Change the default reject code from 5.7.1 to specified value
rejectscore: Set spamass-milter to reject any mail that is at or above the
specified
threshold
rejecttext: Change the text that is given upon mail reject from the default
of 'Blocked by SpamAssassin'
sendmailpath: Specify the path to sendmail. This is only useful if
expand_user is set and spamass-milter is unable to find sendmail
spamaddress: Send spam to specified address
address: email address to send to
retain_recipients: boolean to decide if the original recipients should be
retained or if X-Spam-Orig-To: headers should be inserted
spamcflags: A string of options to be passed on to spamc
NOTE: the spamass-milter option of -D should be put here as '-d host' as
the -D parameter is deprecated

Default value: `undef`

##### `no_modify_subject`

Data type: `Boolean`

### `spamass_milter::install`

Installs spamass-milter using the defined package

#### Parameters

The following parameters are available in the `spamass_milter::install` class.

##### `ensure`

Data type: `Enum['present', 'absent', 'installed', 'latest']`

If true, will ensure the package as stated (default: installed)
NOTE: the default makes sure it is installed, but will not upgrade
unless changed to latest!

##### `manage_package`

Data type: `Boolean`

If true, will ensure the spamass-milter package (default: true)

##### `package_name`

Data type: `String`

The name of the package to install (default: spamass-milter)

##### `postfix_extension`

Data type: `Boolean`

If true also install postfix extension package (default: true)

##### `postfix_extension_package`

Data type: `String`

The name of the postfix extension package to install (default:
spamass-milter-postfix)

### `spamass_milter::service`

Automatically chooses the correct service to run depending on the configured
options

#### Parameters

The following parameters are available in the `spamass_milter::service` class.

##### `ensure`

Data type: `Stdlib::Ensure::Service`

Ensures the service at the defined level, unless enable is set to
'manual' or 'mask' at which point the module will stop ensuring running
or stopped status

##### `enable`

Data type: `Variant[Boolean, Enum['manual', 'mask']]`

Configure the service to automatically start on system start
true, service starts on system start
false, service does not start on system start (puppet will then ensure it
during it's first run to whatever the ensure value is
manual, service will not be managed by puppet other than the enable value
mask, service will not be managed by puppet other than the enable value

##### `expand_user`

Data type: `Boolean`

Configuration flag to determine which service should be used. This should
follow spamass_milter::config::expand_user !
