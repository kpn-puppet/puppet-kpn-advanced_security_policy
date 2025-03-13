# frozen_string_literal: true

require 'spec_helper'

describe 'advanced_security_policy', if: RUBY_PLATFORM =~ %r{cygwin|mswin|mingw|bccwin|wince|emx} do
  on_supported_os.each do |os, os_facts|
    describe "on #{os}" do
      let(:facts) { os_facts }
      let(:params) { {} }

      it { is_expected.to compile }
      it { is_expected.to contain_class('advanced_security_policy') }
      it { is_expected.to contain_file('C:/Management/advanced_security') }
      it { is_expected.to contain_exec('backup registry.pol') }
      it { is_expected.to contain_file('C:/Windows/System32/LGPO.exe') }
      it { is_expected.to contain_scheduled_task('gpupdate (managed by puppet)') }
    end
  end
end
