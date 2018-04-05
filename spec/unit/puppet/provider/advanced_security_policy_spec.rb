# frozen_string_literal: true

require 'spec_helper'

provider_resource = Puppet::Type.type(:advanced_security_policy)
provider_class    = provider_resource.provider(:lgpo)

describe provider_class do
  subject { provider_class }

  let(:resource) do
    provider_resource.new(
      name:          'Prohibit installation and configuration of Network Bridge on your DNS domain network',
      ensure:        'present',
      configuration: 'Computer',
      registry_key:  'Software\Policies\Microsoft\Windows\Network Connections',
      value_name:    'NC_AllowNetBridge_NLA',
      policy_value:  '1',
    )
  end

  let(:provider) { described_class.new(resource) }

  describe 'provider' do
    it 'is an instance of Puppet::Type::Advanced_security_policy::ProviderLgpo' do
      expect(provider).to be_an_instance_of Puppet::Type::Advanced_security_policy::ProviderLgpo
    end

    it 'responds to function calls' do
      expect(provider).to respond_to(:action)
      expect(provider).to respond_to(:flush)
      expect(provider.class).to respond_to(:instances)
      expect(provider.class).to respond_to(:prefetch)
    end

    describe 'instances' do
      it 'returns policy properties' do
        policies = '; ----------------------------------------------------------------------
; PARSING Computer POLICY
; Source file:  C:\\Windows\\System32\\GroupPolicy\\Machine\\Registry.pol

Computer
Software\\Policies\\Microsoft\\Windows\\EventLog\\Application
MaxSize
DWORD:32768'
        provider.class.stubs(securitypol: policies)
        provider.class.stubs(registry_file_exists: true)
        provider.class.expects(:new)
                .with(
                  name:         'Application: Specify the maximum log file size (KB)',
                  ensure:       :present,
                  policy_value: '32768',
                )
        provider.class.instances
      end
    end

    describe 'flush' do
      before :each do
        provider.class.stubs(:write_setting_to_tempfile)
                .with('Computer', 'Software\\Policies\\Microsoft\\Windows\\Network Connections', 'NC_AllowNetBridge_NLA', 'DWORD:1')

        provider.instance_variable_set(
          :@property_flush,
          configuration: 'Computer',
          registry_key:  'Software\\Policies\\Microsoft\\Windows\\Network Connections',
          value_name:    'NC_AllowNetBridge_NLA',
          action:        'DWORD:1',
        )
      end

      describe 'securitypol should be called' do
        it 'calls securitypol in order to set policies' do
          provider.class.stubs(:security_policy)
          provider.expects(:securitypol)
                  .with('/t', 'C:\\windows\\temp\\lgpotemp.txt')
          provider.flush
        end
      end
    end

    describe 'self.' do
      describe 'prefetch' do
        context 'with valid resource' do
          it 'stores prov into resource.provider' do
            prov_mock = mock
            prov_mock.expects(:name).returns('foo')
            resource_mock = mock
            resource_mock.expects(:provider=)
            resources = {}
            resources['foo'] = resource_mock
            provider.class.stubs(instances: [prov_mock])
            provider.class.prefetch(resources)
          end
        end
      end
    end
  end
end
