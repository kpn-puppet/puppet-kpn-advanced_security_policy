# frozen_string_literal: true

require 'spec_helper'

provider_resource = Puppet::Type.type(:advanced_security_policy)
provider_class    = provider_resource.provider(:lgpo)

describe provider_class, if: RUBY_PLATFORM =~ %r{cygwin|mswin|mingw|bccwin|wince|emx} do
  subject { provider_class }

  let(:resource) do
    provider_resource.new(
      name: 'Prohibit installation and configuration of Network Bridge on your DNS domain network',
      ensure: 'present',
      configuration: 'Computer',
      registry_key: 'Software\Policies\Microsoft\Windows\Network Connections',
      value_name: 'NC_AllowNetBridge_NLA',
      policy_value: '1',
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
        allow(provider.class).to receive(:registry_file_exists_machine).and_return(true)
        allow(provider.class).to receive(:securitypol).and_return(policies)
        expect(provider.class.instances.first.provider).to eq(:absent)
        expect(provider.class.instances.first.name).to eq('Application: Specify the maximum log file size (KB)')
        expect(provider.class.instances.first.policy_value).to eq('32768')
        expect(provider.class.instances.first).to be_a(provider.class)
      end
    end

    describe 'flush' do
      before :each do
        allow(provider.class).to receive(:write_setting_to_tempfile).with(
          'Computer',
          'Software\\Policies\\Microsoft\\Windows\\Network Connections',
          'NC_AllowNetBridge_NLA',
          'DWORD:1',
        )

        provider.instance_variable_set(
          :@property_flush,
          configuration: 'Computer',
          registry_key: 'Software\\Policies\\Microsoft\\Windows\\Network Connections',
          value_name: 'NC_AllowNetBridge_NLA',
          action: 'DWORD:1',
        )
      end

      describe 'securitypol should be called' do
        it 'calls securitypol in order to delete policies' do
          provider.instance_variable_set(
            :@property_flush,
            configuration: 'Computer',
            registry_key: 'Software\\Policies\\Microsoft\\Windows\\Network Connections',
            value_name: 'NC_AllowNetBridge_NLA',
            action: 'DELETE',
          )
          allow(provider.class).to receive(:security_policy)
          expect(provider).to receive(:securitypol).with('/t', 'C:\\windows\\temp\\lgpotemp.txt')
          provider.flush
        end

        it 'calls securitypol in order to set policies' do
          provider.instance_variable_set(
            :@property_flush,
            configuration: 'Computer',
            registry_key: 'Software\\Policies\\Microsoft\\Windows\\Network Connections',
            value_name: 'NC_AllowNetBridge_NLA',
            action: 'DWORD:1',
          )
          allow(provider.class).to receive(:security_policy)
          expect(provider).to receive(:securitypol).with('/t', 'C:\\windows\\temp\\lgpotemp.txt')
          provider.flush
        end
      end
    end

    describe 'self.' do
      let(:provider) do
        described_class.new
      end

      describe 'prefetch' do
        context 'with valid resource' do
          it 'stores prov into resource.provider' do
            prov_mock = instance_double('Provider', name: 'foo')
            resource_mock = instance_double('Resource')
            expect(resource_mock).to receive(:provider=)
            resources = {}
            resources['foo'] = resource_mock
            allow(provider.class).to receive(:instances).and_return([prov_mock])
            provider.class.prefetch(resources)
          end
        end
      end
    end
  end

  describe Puppet::Type.type(:advanced_security_policy).provider(:lgpo) do
    let(:securitypol_output) do
      "Computer\nregistry_key\nvalue_name\naction\n\n"
    end

    let(:provider) do
      described_class.new
    end

    let(:instance) { provider.class.new(name: 'Application: Specify the maximum log file size (KB)', ensure: :present, policy_value: '32768') }

    before(:each) do
      allow(described_class).to receive(:registry_file_exists_machine).and_return(true)
      allow(described_class).to receive(:registry_file_exists_user).and_return(false)
      allow(described_class).to receive(:securitypol).and_return(securitypol_output)
    end

    it 'checks the provider of the first instance' do
      instances = provider.class.instances
      unless instances.empty?
        expect(instances.first.provider).to eq(:absent)
        expect(instances.first).to be_a(provider.class)
      end
    end

    it 'creates an instance with the correct name' do
      expect(instance.name).to eq('Application: Specify the maximum log file size (KB)')
    end

    it 'creates an instance with the correct ensure value' do
      expect(instance.ensure).to eq(:present)
    end

    it 'creates an instance with the correct policy_value' do
      expect(instance.policy_value).to eq('32768')
    end
  end
end
