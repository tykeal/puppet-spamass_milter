# frozen_string_literal: true

require 'spec_helper'

describe 'spamass_milter::install' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_package('spamass-milter') }
      it { is_expected.to contain_package('spamass-milter-postfix') }

      context 'with manage_package => false' do
        let(:params) do
          {
            manage_package: false,
          }
        end

        it { is_expected.not_to contain_package('spamass-milter') }
        it { is_expected.not_to contain_package('spamass-milter-postfix') }
      end

      context 'with different package names' do
        let(:params) do
          {
            package_name: 'foo',
            postfix_extension_package: 'bar',
          }
        end

        it { is_expected.to contain_package('foo') }
        it { is_expected.to contain_package('bar') }
      end

      context 'with postfix_extension => false' do
        let(:params) do
          {
            postfix_extension: false,
          }
        end

        it { is_expected.to contain_package('spamass-milter') }
        it { is_expected.not_to contain_package('spamass-milter-postfix') }
      end
    end
  end
end
