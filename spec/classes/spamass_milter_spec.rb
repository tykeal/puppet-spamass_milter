# frozen_string_literal: true

require 'spec_helper'

describe 'spamass_milter' do
  on_supported_os.each do |os, os_facts|
    context "on #{os}" do
      let(:facts) { os_facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('spamass_milter::install') }
      it { is_expected.to contain_class('spamass_milter::config') }
      it { is_expected.to contain_class('spamass_milter::service') }
    end
  end
end
