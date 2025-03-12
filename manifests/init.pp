# class advanced_security_policy 
class advanced_security_policy {
  file { 'C:/Management/advanced_security':
    ensure => 'directory',
  }

  exec { 'backup registry.pol':
    command => 'powershell Copy-Item C:/Windows/System32/GroupPolicy/Machine/Registry.pol C:/Management/advanced_security/Registry.pol',
    path    => 'C:/Windows/System32/WindowsPowerShell/v1.0',
    creates => 'C:/Management/advanced_security/Registry.pol',
    # onlyif  => 'powershell Test-Path C:/Windows/System32/GroupPolicy/Machine/Registry.pol',
  }

  file { 'C:/Windows/System32/LGPO.exe':
    ensure => file,
    source => 'puppet:/modules/advanced_security_policy/LGPO.exe',
  }

  if $facts['domainrole'] == 'Standalone Server' {
    scheduled_task { 'gpupdate (managed by puppet)':
      ensure  => present,
      enabled => true,
      command => 'C:/Windows/system32/gpupdate.exe',
      trigger => {
        schedule         => daily,
        start_time       => '00:30',
        minutes_interval => 30,
      },
      user    => 'SYSTEM',
    }
  }
}
