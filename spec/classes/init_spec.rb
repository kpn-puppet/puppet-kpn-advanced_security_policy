# frozen_string_literal: true

require 'spec_helper'

describe 'advanced_security_policy', if: RUBY_PLATFORM =~ %r{cygwin|mswin|mingw|bccwin|wince|emx} do
  def global_facts(facts, _os)
    facts.merge(os: { family: 'windows', release: { major: facts[:os]['release']['major'] }, windows: { system32: 'C:/Windows/system32' } })
  end

  on_supported_os.each do |os, facts|
    describe "on #{os}" do
      let(:facts) { global_facts(facts, os) }

      it { is_expected.to compile }
      it { is_expected.to contain_class('advanced_security_policy') }
      it { is_expected.to contain_file('c:/Management/advanced_security') }
      it { is_expected.to contain_exec('backup registry.pol') }
      it { is_expected.to contain_file('C:/Windows/System32/LGPO.exe') }

      if facts[:os]['release']['major'].match?(%r{2012|2016|2019})
        it { is_expected.to contain_scheduled_task('gpupdate (managed by puppet)') }
      end
    end
  end
end
