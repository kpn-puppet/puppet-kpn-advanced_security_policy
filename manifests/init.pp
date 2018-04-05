# class advanced_security_policy 
class advanced_security_policy {
  file { 'C:/Windows/System32/LGPO.exe':
    ensure => file,
    source => 'puppet:///modules/advanced_security_policy/LGPO.exe',
    owner  => 'Administrators',
    group  => 'Administrators',
    mode   => '0770',
  }
}
