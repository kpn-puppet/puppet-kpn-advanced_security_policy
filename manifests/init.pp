# class advanced_security_policy 
class advanced_security_policy {
  file { 'c:/Management/advanced_security':
    ensure => 'directory',
  }

  exec { 'backup registry.pol':
    command => 'powershell Copy-Item C:\Windows\System32\GroupPolicy\Machine\Registry.pol c:\Management\advanced_security',
    path    => 'C:\Windows\System32\WindowsPowerShell\v1.0',
    creates => 'C:\Management\advanced_security\Registry.pol',
    onlyif  => 'C:\Windows\System32\cmd.exe /c dir C:\Windows\System32\GroupPolicy\Machine\Registry.pol',
  }

  file { 'C:/Windows/System32/LGPO.exe':
    ensure => file,
    source => 'puppet:///modules/advanced_security_policy/LGPO.exe' # lint:ignore:source_without_rights
  }

  if $facts['domainrole'] == 'Standalone Server' and $facts['os']['release']['major'] !~ '2008' {
    scheduled_task { 'gpupdate (managed by puppet)':
      ensure  => present,
      enabled => true,
      command => 'C:\Windows\system32\gpupdate.exe',
      trigger => {
        schedule         => daily,
        start_time       => '00:30',
        minutes_interval => 30,
      },
      user    => 'SYSTEM',
    }
  }
}
