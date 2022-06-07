# frozen_string_literal: true

require 'spec_helper'

describe 'advanced_security_policy' do
  on_supported_os.each do |os, facts|
    describe "on #{os}" do
      let(:facts) { facts }

      it { is_expected.to compile }
      it { is_expected.to contain_class('advanced_security_policy') }
      it { is_expected.to contain_file('c:/Management/advanced_security') }
      it { is_expected.to contain_exec('backup registry.pol') }
      it { is_expected.to contain_file('C:/Windows/System32/LGPO.exe') }
    end
  end
end
