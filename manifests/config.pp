# @summary Configure spamass-milter
#
# Configures the /etc/sysconfig/spamass-milter file based upon hiera data
#
# @param expand_user
#   If set then spamass-milter will pass -x and perform virtusertable and alias
#   expansion. This requires setting the -u setting which is done via
#   options[default_account][defaultuser] (default false)
#   NOTE: using this setting will cause spamass-milter to run as root instead
#   of the less privileged sa-milter
# @param no_modify_headers
#   If set then spamass-milter will pass -M to disable the 'X-Spam-*' headers
#   (default: false)
# #param no_modify_subject
#   If set then spamass-milter will pass -m to disable the modification of
#   'Subject:' and 'Content-Type:' headers as well as the message body
#   (default: false, recommend true with option rejectscore set)
# @param socket
#   Takes one of two hash definitions:
#   { path => Stdlib::Unixpath } which is a path to socket created for
#   commuication with spamassin
#   Or
#   { port => Stdlib::Port, host => Stdlib::Host } which will create
#   an inet socket for communication
#   ( default: port: 8895, host: 127.0.0.1 which is different from the EPEL
#   configuration of /run/spamass-milter/spamass-milter.sock)
# @param postfix_extension
#   Is the postfix extension being configured as well
#   (defaults to whatever spamass_milter::install::install_postfix_extension is)
# @param options
#   Options structure for all supported flags and configuration
#   debug: Configures the debug flags
#     Valid options are:
#       func, misc, net, poll, rcpt, spamc, str, uori, 1, 2, 3
#   default_account: Configures the default user and default domain options
#     NOTE: Per the design of this module, if one is to be set, then both must
#     be set
#   ignore: An array of Stdlib::IP::Address objects that will be configured for
#     ignoring by spamass-milter
#   rejectcode: Change the default reject code from 5.7.1 to specified value
#   rejectscore: Set spamass-milter to reject any mail that is at or above the
#   specified
#     threshold
#   rejecttext: Change the text that is given upon mail reject from the default
#     of 'Blocked by SpamAssassin'
#   sendmailpath: Specify the path to sendmail. This is only useful if
#     expand_user is set and spamass-milter is unable to find sendmail
#   spamaddress: Send spam to specified address
#     address: email address to send to
#     retain_recipients: boolean to decide if the original recipients should be
#       retained or if X-Spam-Orig-To: headers should be inserted
#   spamcflags: A string of options to be passed on to spamc
#     NOTE: the spamass-milter option of -D should be put here as '-d host' as
#     the -D parameter is deprecated
class spamass_milter::config (
  # Required
  Boolean $expand_user,
  Boolean $no_modify_headers,
  Boolean $no_modify_subject,
  Variant[
    Struct[{
      path => Stdlib::Unixpath,
    }],
    Struct[{
      port => Stdlib::Port,
      host => Stdlib::Host,
    }]] $socket,
  Boolean $postfix_extension,

  # Optional
  Optional[Struct[{
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
  }]] $options = undef,
) {
  # if $expand_user is set then $options['default_account'] must be filled out
  if $expand_user {
    $_fail_message = 'Setting expand_user to true requires a defaultuser defined'
    if $options {
      unless $options['default_account'] {
        fail($_fail_message)
      }
    } else {
      fail($_fail_message)
    }
  }

  file {'/etc/sysconfig/spamass-milter':
    ensure  => file,
    owner   => 'root',
    group   => 'root',
    mode    => '0644',
    content => epp("${module_name}/sysconfig-spamass-milter.epp",
      {
        expand_user       => $expand_user,
        no_modify_headers => $no_modify_headers,
        no_modify_subject => $no_modify_subject,
        socket            => $socket,
        postfix_extension => $postfix_extension,
        options           => $options,
      },
    )
  }

  if $postfix_extension {
    file {'/etc/sysconfig/spamass-milter-postfix':
      ensure  => file,
      owner   => 'root',
      group   => 'root',
      mode    => '0644',
      content => epp("${module_name}/sysconfig-spamass-milter-postfix.epp",
        {
          socket => $socket,
        }
      )
    }
  }
}
