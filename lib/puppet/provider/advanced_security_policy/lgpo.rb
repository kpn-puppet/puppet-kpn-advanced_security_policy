# frozen_string_literal: true

# Provider

require 'puppet_x/asp/security_policy'

ADVANCED_TEMP = 'C:\\windows\\temp\\lgpotemp.txt'
REGISTRY_FILE_MACHINE = 'C:\\Windows\\System32\\GroupPolicy\\Machine\\Registry.pol'
REGISTRY_FILE_USER = 'C:\\Windows\\System32\\GroupPolicy\\User\\Registry.pol'

Puppet::Type.type(:advanced_security_policy).provide(:lgpo) do
  confine    osfamily: :windows
  defaultfor osfamily: :windows

  commands securitypol: 'lgpo.exe'

  mk_resource_methods

  def initialize(value = {})
    super(value)
    @property_flush = {}
  end

  def flush
    policy_hash = AdvancedSecurityPolicy.find_mapping_from_policy_desc(resource[:name])

    reg_type = policy_hash[:reg_type]

    if policy_hash[:data_type] == 'boolean'
      policy_value = (resource[:policy_value] == 'enabled') ? policy_hash[:enabled_value] : policy_hash[:disabled_value]
    elsif !resource[:policy_value].nil?
      # policy_value = resource[:policy_value].downcase
      policy_value = resource[:policy_value]
    end

    configuration = policy_hash[:configuration]
    registry_key  = policy_hash[:registry_key]
    value_name    = policy_hash[:value_name]

    action = (resource[:action] == 'DELETE') ? 'DELETE' : "#{reg_type}:#{policy_value}"

    self.class.write_setting_to_tempfile(configuration, registry_key, value_name, action)
    securitypol('/t', ADVANCED_TEMP)

    @property_hash = resource.to_hash
  end

  def self.write_setting_to_tempfile(configuration, registry_key, value_name, action)
    out_file = File.new(ADVANCED_TEMP, 'w')
    out_file.puts(configuration.to_s)
    out_file.puts(registry_key.to_s)
    out_file.puts(value_name.to_s)
    out_file.puts(action.to_s)
    out_file.close
  end

  def self.registry_file_exists_machine
    File.file? REGISTRY_FILE_MACHINE
  end

  def self.registry_file_exists_user
    File.file? REGISTRY_FILE_USER
  end

  def exists?
    # does the policy setting exist?
    @property_hash[:ensure] == :present
  end

  def create
    # create the policy setting
    resource[:ensure]        = :present
  end

  def destroy
    # reset the policy setting
    @property_hash[:ensure]  = :absent
    @resource[:action]       = 'DELETE'
  end

  def self.configuration_is(action, policy_values)
    if ['DELETE', 'SZ:'].include?(action)
      ensure_value = :absent
      policy_setting = action
    else
      ensure_value = :present
      # policy_setting = (policy_values[:data_type] == 'boolean') ? policy_datatype_boolean(action, policy_values[:enabled_value]) : action.split(':')[1].downcase
      policy_setting = (policy_values[:data_type] == 'boolean') ? policy_datatype_boolean(action, policy_values[:enabled_value]) : action.split(':')[1]
    end

    [ensure_value, policy_setting]
  end

  def self.policy_datatype_boolean(action, enabled_value)
    (action.split(':')[1] == enabled_value) ? 'enabled' : 'disabled'
  end

  def self.instances
    instances = []

    if registry_file_exists_machine
      categories = securitypol('/parse', '/q', '/m', REGISTRY_FILE_MACHINE)
      line_array = categories.split("\n").drop(4)
      entries    = line_array.each_slice(5)

      entries.map do |entry_array|
        configuration = entry_array[0]

        next unless configuration == 'Computer'

        registry_key   = entry_array[1]
        value_name     = entry_array[2]
        action         = entry_array[3]
        registry_value = "#{registry_key}\\#{value_name}"
        policy_desc, policy_values = AdvancedSecurityPolicy.find_mapping_from_policy_name(registry_value)

        next if policy_desc.nil?

        ensure_value, policy_setting = configuration_is(action, policy_values)
        policy_hash = {
          name: policy_desc,
          ensure: ensure_value,
          policy_value: policy_setting,
        }
        instances << new(policy_hash)
      end
    end

    if registry_file_exists_user
      categories = securitypol('/parse', '/q', '/u', REGISTRY_FILE_USER)
      line_array = categories.split("\n").drop(4)
      entries    = line_array.each_slice(5)

      entries.map do |entry_array|
        configuration = entry_array[0]

        next unless configuration == 'User'

        registry_key   = entry_array[1]
        value_name     = entry_array[2]
        action         = entry_array[3]
        registry_value = "#{registry_key}\\#{value_name}"
        policy_desc, policy_values = AdvancedSecurityPolicy.find_mapping_from_policy_name(registry_value)

        next if policy_desc.nil?

        ensure_value, policy_setting = configuration_is(action, policy_values)
        policy_hash = {
          name: policy_desc,
          ensure: ensure_value,
          policy_value: policy_setting,
        }
        instances << new(policy_hash)
      end
    end

    instances
  end

  def self.prefetch(resources)
    policies = instances
    resources.each_key do |name|
      if (provider = policies.find { |policy| policy.name == name })
        resources[name].provider = provider
      end
    end
  end
end
