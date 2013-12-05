Pod::Spec.new do |s|
  s.name     = 'MCKillSwitch'
  s.version  = '0.2.0'
  s.license  = 'BSD 3-Clause'
  s.summary  = 'Stop a version of your app from working, promping user to upgrade.'
  s.homepage = 'https://github.com/mirego/MCKillswitch'
  s.authors  = { 'Mirego, Inc.' => 'info@mirego.com' }
  s.source   = { :git => 'https://github.com/mirego/MCKillswitch.git', :tag => s.version.to_s }
  s.source_files = 'MCKillSwitch/**/*.{h,m}'
  s.requires_arc = true
  
  s.platform = :ios, '5.0'
end