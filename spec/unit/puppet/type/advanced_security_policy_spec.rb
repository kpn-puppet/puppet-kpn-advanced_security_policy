# frozen_string_literal: true

require 'spec_helper'

type_class = Puppet::Type.type(:advanced_security_policy)

EXAMPLE = {
  name: 'Application: Specify the maximum log file size (KB)',
  action: 'DWORD:0001',
}.freeze

describe type_class, if: RUBY_PLATFORM =~ %r{cygwin|mswin|mingw|bccwin|wince|emx} do
  let :params do
    [
      :policy_key,
    ]
  end

  let :properties do
    [
      :action,
    ]
  end

  it 'has expected properties' do
    properties.each do |property|
      expect(type_class.properties.map(&:name)).to be_include(property)
    end
  end

  it 'has expected parameters' do
    params.each do |param|
      expect(type_class.parameters).to be_include(param)
    end
  end

  it 'requires a policy_key' do
    expect {
      type_class.new({})
    }.to raise_error(Puppet::Error, 'Title or name must be provided')
  end
end
