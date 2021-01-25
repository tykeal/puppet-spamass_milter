# frozen_string_literal: true

require 'spec_helper'

describe 'spamass_milter::service' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it {
        is_expected.to contain_service('spamass-milter').with(
          ensure: 'running',
          enable: true,
        )
      }
      it {
        is_expected.to contain_service('spamass-milter-root').with(
          ensure: 'stopped',
          enable: false,
        )
      }

      context "with ensure => stopped" do
        let(:params) do
          {
            ensure: 'stopped',
          }
        end

        it {
          is_expected.to contain_service('spamass-milter').with(
            ensure: 'stopped',
          )
        }
        it {
          is_expected.to contain_service('spamass-milter-root').with(
            ensure: 'stopped',
          )
        }
      end

      context "with enable => manual" do
        let(:params) do
          {
            enable: 'manual',
          }
        end

        it {
          is_expected.to contain_service('spamass-milter').with(
            ensure: nil,
            enable: 'manual',
          )
        }
        it {
          is_expected.to contain_service('spamass-milter-root').with(
            ensure: 'stopped',
            enable: false,
          )
        }
      end

      context "with expand_user => true" do
        let(:params) do
          {
            expand_user: true,
          }
        end

        it {
          is_expected.to contain_service('spamass-milter').with(
            ensure: 'stopped',
            enable: false,
          )
        }
        it {
          is_expected.to contain_service('spamass-milter-root').with(
            ensure: 'running',
            enable: true,
          )
        }

        context "with enable => manual" do
          let(:params) do
            {
              enable: 'manual',
              expand_user: true,
            }
          end

          it {
            is_expected.to contain_service('spamass-milter').with(
              ensure: 'stopped',
              enable: false,
            )
          }
          it {
            is_expected.to contain_service('spamass-milter-root').with(
              ensure: nil,
              enable: 'manual',
            )
          }
        end
      end
    end
  end
end
