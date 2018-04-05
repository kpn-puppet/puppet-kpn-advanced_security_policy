# frozen_string_literal: true

# Type
Puppet::Type.newtype(:advanced_security_policy) do
  desc 'advanced_security_policy type for windows'

  ensurable

  newparam(:policy_key, namevar: true) do
    desc 'The Advanced Security Setting name. What you see in the GUI.'
    validate do |value|
      raise 'Advanced Security Setting name should be a string' unless value.is_a? String
    end
  end

  newproperty(:configuration) do
    desc 'The configuration specifies whether the setting is for Computer Configuration, User Configuration, or an MLGPO User Configuration'
  end

  newproperty(:registry_key) do
    desc 'The registry Key specifies the name of a registry key'
  end

  newproperty(:value_name) do
    desc 'The value_name is the name of the registry value to modify'
  end

  newproperty(:reg_type) do
    desc 'The reg_type is the registry type of the registry value to modify'
  end

  newproperty(:policy_value) do
    desc 'The policy_value is setting of the registry value to modify'
    validate do |value|
      raise 'Value Name should be a String' unless value.is_a? String
    end
  end

  newproperty(:data_type) do
    desc 'The data_type specifies if the policy setting will be used as a boolean or a string value'
  end

  newproperty(:enabled_value) do
    desc 'The enabled_value specifies the result of setting enabled. Enabled would expect to result in 1 but may also be 0'
  end

  newproperty(:disabled_value) do
    desc 'The enabled_value specifies the result of setting enabled. Enabled would expect to result in 1 but may also be 0'
  end

  newproperty(:action) do
    desc 'Action specifies what action to take'
  end
end
