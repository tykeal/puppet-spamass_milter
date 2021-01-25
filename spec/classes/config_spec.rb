# frozen_string_literal: true

require 'spec_helper'

describe 'spamass_milter::config' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_file('/etc/sysconfig/spamass-milter').with(
          'content' => '# DO NOT EDIT: File managed by puppet

### Override for your different local config if necessary
#SOCKET=/run/spamass-milter/spamass-milter.sock

### You may add configuration parameters here, see spamass-milter(1)
###
### Note that the -x option for expanding aliases and virtusertable entries
### only works if spamass-milter is run as root; you will need to use
### spamass-milter-root.service instead of spamass-milter.service if you
### wish to do this but otherwise it\'s best to run as the unprivileged user
### sa-milt by using the normal spamass-milter.service
#EXTRA_FLAGS="-m -r 15"
EXTRA_FLAGS=""
',
        )
      }

      it {
        is_expected.to contain_file('/etc/sysconfig/spamass-milter-postfix') \
          .with(
            'content' => '# DO NOT EDIT: File managed by puppet

# For Postfix support, use a postfix-group-writable socket
# for communication with the MTA
SOCKET="/run/spamass-milter/postfix/sock"
SOCKET_OPTIONS="-g postfix"
',
        )
      }

      # Test different options
      context "with expand_user set" do
        context "with no options defined" do
          let(:params) do
            {
              expand_user: true,
            }
          end

          it { is_expected.not_to compile }
        end

        context "with options set, but not default_account" do
          let(:params) do
            {
              expand_user: true,
              options: {
                rejectscore: 3,
              }
            }
          end

          it { is_expected.not_to compile }
        end

        context "with options set, and default_account configured" do
          let(:params) do
            {
              expand_user: true,
              options: {
                default_account: {
                  defaultdomain: 'bar',
                  defaultuser: 'foo',
                }
              }
            }
          end

          it {
            is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
            .with_content(/^EXTRA_FLAGS=".* -x .*"$/)
          }
        end
      end

      context "with debug set" do
        let(:params) do
          {
            options: {
              debug: ['func'],
            }
          }
        end

        it {
          is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
          .with_content(/^EXTRA_FLAGS=" -d func"$/)
        }

        context "with more than debug" do
          let(:params) do
            {
              options: {
                debug: ['func', 'misc'],
              }
            }
          end

          it {
            is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
            .with_content(/^EXTRA_FLAGS=" -d func,misc"$/)
          }
        end
      end

      context "with default_account defined" do
        let(:params) do
          {
            options: {
              default_account: {
                defaultdomain: 'bar',
                defaultuser: 'foo',
              }
            }
          }
        end

        it {
          is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
            .with_content(/^EXTRA_FLAGS=" -u foo -e bar"$/)
        }
      end

      context "with ignore set" do
        let(:params) do
          {
            options: {
              ignore: [
                '127.0.0.1',
              ],
            }
          }
        end

        it {
          is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
            .with_content(/^EXTRA_FLAGS=" -i 127.0.0.1"$/)
        }

        context "with more than one ignore set" do
          let(:params) do
            {
              options: {
                ignore: [
                  '127.0.0.1',
                  '::1',
                ],
              }
            }
          end

          it {
            is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
              .with_content(/^EXTRA_FLAGS=" -i 127.0.0.1 -i ::1"$/)
          }
        end
      end

      context "with reject code set" do
        let(:params) do
          {
            options: {
              rejectcode: 'foo'
            }
          }
        end

        it {
          is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
            .with_content(/^EXTRA_FLAGS=" -C foo"$/)
        }
      end

      context "with reject score set" do
        let(:params) do
          {
            options: {
              rejectscore: 15,
            }
          }
        end

        it {
          is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
            .with_content(/^EXTRA_FLAGS=" -r 15"$/)
        }
      end

      context "with reject text set" do
        let(:params) do
          {
            options: {
              rejecttext: 'foo'
            }
          }
        end

        it {
          is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
            .with_content(/^EXTRA_FLAGS=" -R \\"foo\\""$/)
        }
      end

      context "with sendmailpath set" do
        let(:params) do
          {
            options: {
              sendmailpath: '/foo',
            }
          }
        end

        it {
          is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
            .with_content(/^EXTRA_FLAGS=" -S \/foo"$/)
        }
      end

      context "with spamaddress set" do
        context "with retain_recipients => true" do
          let(:params) do
            {
              options: {
                spamaddress: {
                  address: 'foo@bar.com',
                  retain_recipients: true,
                }
              }
            }
          end

          it {
            is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
              .with_content(/^EXTRA_FLAGS=" -B foo@bar.com"$/)
          }
        end

        context "with retain_recipients => false" do
          let(:params) do
            {
              options: {
                spamaddress: {
                  address: 'foo@bar.com',
                  retain_recipients: false,
                }
              }
            }
          end

          it {
            is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
              .with_content(/^EXTRA_FLAGS=" -b foo@bar.com"$/)
          }
        end
      end

      context "with spamcflags set" do
        let(:params) do
          {
            options: {
              spamcflags: 'foo',
            }
          }
        end

        it {
          is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
            .with_content(/^EXTRA_FLAGS=" -- foo"$/)
        }
      end

      context "with postfix_extension => false" do
        let(:params) do
          {
            postfix_extension: false,
          }
        end

        context "with socket file" do
          let(:params) do
            {
              postfix_extension: false,
              socket: {
                'path' => '/foo',
              },
            }
          end

          it {
            is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
              .with_content(/^SOCKET=\/foo$/)
          }
        end

        context "with inet port" do
          let(:params) do
            {
              postfix_extension: false,
              socket: {
                'port' => 8895,
                'host' => '127.0.0.1',
              }
            }
          end

          it {
            is_expected.to contain_file('/etc/sysconfig/spamass-milter') \
              .with_content(/^SOCKET=inet:8895@127\.0\.0\.1$/)
          }
        end

        it {
          is_expected.not_to \
            contain_file('/etc/sysconfig/spamass-milter-postfix')
        }
      end
    end
  end
end
