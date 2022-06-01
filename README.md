# advanced_security_policy

#### Table of Contents

- [advanced_security_policy](#advanced_security_policy)
      - [Table of Contents](#table-of-contents)
  - [Overview](#overview)
  - [Module Description](#module-description)
  - [Setup](#setup)
    - [Setup Requirements](#setup-requirements)
    - [What advanced_security_policy affects](#what-advanced_security_policy-affects)
    - [Beginning with advanced_security_policy](#beginning-with-advanced_security_policy)
  - [Usage](#usage)
    - [Parameters](#parameters)
      - [policy(resource) name (required)](#policyresource-name-required)
      - [ensure](#ensure)
      - [policy_value](#policy_value)
    - [Examples](#examples)
      - [Example: Setting multiple security policies](#example-setting-multiple-security-policies)
  - [Reference](#reference)
    - [Defined Types](#defined-types)
    - [Provider](#provider)
  - [Limitations](#limitations)
  - [Development](#development)

## Overview
This module sets and enforces the advanced security policies for windows.

## Module Description
This module uses LGPO.exe (v2.2) to configure the advanced security policies on Windows.
LGPO.exe is a command-line utility that is designed to help automate management of
Local Group Policy. It can import and apply settings from Registry Policy (Registry.pol)
files, security templates, Advanced Auditing backup files, as well as from formatted
“LGPO text” files.

## Setup

### Setup Requirements

This module requires:
- ADMX and ADML files with the policy settings to be set (in `C:\Windows\PolicyDefinitions`)
- LGPO.exe needs to be installed in `C:\Windows\System32` (Add the following code)
  ```puppet
    include advanced_security_policy
  ```

### What advanced_security_policy affects
- Advanced security policies.
- `C:\Windows\System32\GroupPolicy\Machine\Registry.pol`
- A backup is made of `C:\Windows\System32\GroupPolicy\Machine\Registry.pol` and is placed in `C:\Management\advanced_security\Registry.pol`

### Beginning with advanced_security_policy
To start using advanced_security_policy,
simply include the module and add the defined type statements in your profile.
Then configure the policies you want to set. (for example in hiera)

## Usage

**When using `Configure SMB v1 client driver` you may also need to set `Configure SMB v1 client` to `['Bowser','MRxSmb20','NSI']` due to dependencies for this service**

### Parameters

#### policy(resource) name (required)
Type: 'String'
Default: '$title'
Values: Any valid advanced security subcategory
Description: The policy name matches the name in the policy editor

#### ensure
Type: 'String'
Default: 'present'
Values: 'present' or 'absent'
Description: When a policy is set, ensure will be 'present'. If a policy is to be set as 'not configured' then ensure must be set to 'absent'.
#### policy_value
Type: 'String'
Values: 'enabled', 'disabled' or a value
Description: This is the value to be set for the policy. This can be 'enabled', 'disabled' or a value to be set.

### Examples

#### Example: Setting multiple security policies
```puppet
  advanced_security_policy {'Turn off Autoplay':
    policy_value => '255',
  }

  advanced_security_policy {Configuration of wireless settings using Windows Connect Now':
    policy_value => 'disabled'
  }

  advanced_security_policy {'MSS: (AutoAdminLogon) Enable Automatic Logon (not recommended)':
    policy_value => 'enabled',
  }

  advanced_security_policy {'Security: Specify the maximum log file size (KB)':
    ensure         => 'absent',
  }
```

## Reference

### Defined Types

- advanced_security_policy

### Provider
- securitypolicy


## Limitations
This is where you list OS compatibility, version compatibility, etc.

This module works on:

- Windows 2008 R2
- Windows 2012 R2
- Windows 2016
- Windows 2019
- Windows 2022

## Development

You can contribute by submitting issues, providing feedback and joining the discussions.

Go to: `https://github.com/kpn-puppet/puppet-kpn-advanced_security_policy`

If you want to fix bugs, add new features etc:
- Fork it
- Create a feature branch ( git checkout -b my-new-feature )
- Apply your changes and update rspec tests
- Run rspec tests ( bundle exec rake spec )
- Commit your changes ( git commit -am 'Added some feature' )
- Push to the branch ( git push origin my-new-feature )
- Create new Pull Request
