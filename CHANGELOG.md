# Changelog for Advanced Security Policy

2025-01-23 Release 4.1.0

- update module to pe8 and pdk version to 3.4.0
- fix init and rspec for pe8

2024-12-10 4.0.1

- add policy Do not allow client printer redirection

2024-01-08 Release 4.0.0

- Convert code to PDK

2023-11-20 Release 3.1.0

- Add new policies:
  - 'Configure RPC packet level privacy setting for incoming connections'
  - 'Configure NetBIOS settings'
  - 'Configure Redirection Guard'
  - 'Configure RPC connection settings: Protocol to use for outgoing RPC connections'
  - 'Configure RPC listener settings: Protocols to allow for incoming RPC connections'
  - 'Configure RPC listener settings: Authentication protocol to use for incoming RPC connections'
  - 'Configure RPC over TCP port'
  - 'Manage processing of Queue-specific files'
  - 'Allow Custom SSPs and APs to be loaded into LSASS'
  - 'Turn off cloud optimized content'
  - 'Enable App Installer'
  - 'Enable App Installer Experimental Features'
  - 'Enable App Installer Hash Override'
  - 'Enable App Installer ms-appinstaller protocol'
  - 'Do not allow WebAuthn redirection'
  - 'Allow search highlights'
  - 'Enable MPR notifications for the system'

2022-12-01 Release 3.0.1

- Add Allow UI Automation redirection
- Add Do not allow location redirection

2022-05-12 Release 3.0.0

- add User configuration policies
- update 'Minimize the number of simultaneous connections to the Internet or a Windows Domain' policy 
- fix 'Configure detection for potentially unwanted applications' policy (removed spaces)
- add windows 2022 extra checks

2022-05-11 Release 2.6.0

- Add Firewall settings to policy

2020-12-23 Release 2.5.3

- fix 'Turn off the offer to update to the latest version of Windows' policy

2020-06-08 Release 2.5.2

- Add new policy settings
  - 'Configure SMB v1 client'
This setting may need to be set to `['Bowser','MRxSmb20','NSI']` when using the `Configure SMB v1 client driver` policy

2020-05-26 Release 2.5.1

- fix 'Minimize the number of simultaneous connections to the Internet or a Windows Domain'
  enabled = 1 (was 3)
  was changes in previous release but needs more testing and has been rolled back.

2020-05-13 Release 2.5.0

- Add new policy settings
  - Turn off Windows Error Reporting (PCHealth)
  - Do not allow drive redirection
  - Turn on behavior monitoring
  - Scan removable drives
  - Turn on e-mail scanning
  - Configure Attack Surface Reduction rules
  - Prevent users and apps from accessing dangerous websites
  - Configure detection for potentially unwanted applications
  - Minimize the number of simultaneous connections to the Internet or a Windows Domain (enabled = 3, was 1)

2019-09-25 Release 2.4.0

- Add new policy settings for windows 2019
  - Turn Off notifications network usage
  - Encryption Oracle Remediation
  - Enumeration policy for external devices incompatible with Kernel DMA Protection
  - Allow Clipboard synchronization across devices
  - Allow upload of User Activities
  - Require use of specific security layer for remote (RDP) connections
  - Require user authentication for remote connections by using Network Level Authentication
  - Prevent users from modifying settings

2018-01-31 Release 2.3.0

- make a backup of the registry.pol file
- Add new policy settings:
  - Configure SMB v1 client driver
  - Configure SMB v1 server
  - Remote host allows delegation of non-exportable credentials
  - Turn off picture password sign-in
  - Turn off Windows Location Provider
  - Configure local setting override for reporting to Microsoft MAPS
  - Require Mutual Authentication (NETLOGON)
  - Require Mutual Authentication (SYSVOL)
  - Allow Online Tips
  - Configure Authenticated Proxy usage for the Connected User Experience and Telemetry service
  - Allow Message Service Cloud Sync
  - Block all consumer Microsoft account user authentication

2018-11-15 Release 2.2.0

- Add 'gpupdate /force /n' as a scheduled task to fix 'illegal' changes to the registry

2018-04-04 Release 2.1.1

- release to puppet forge

2018-01-23 Release 2.1.0

- allows configurable result for enabled and disabled
- policy_setting has changed to policy_value (same as local_security_policy)

2017-12-19 Release 2.0.1

- unknown (domain) policies already set on the system are ignored
- trying to set an unknown/invalid policy using puppet will still result in an error

2017-12-04 Release 2.0.0

- makes advanced security policy settings ensurable
- policy names are looked up in a list

2017-11-28 Release 1.0.4

- makes the provider case-insensitive

2017-10-11 Release 1.0.3

- change permission on lgpo.exe

2017-07-06 Release 1.0.2

- changed file persmissions because of missing administrator user

2017-07-06 Release 1.0.1

- add file lgpo.exe creation

2017-07-06 Release 1.0.0

- initial commit
