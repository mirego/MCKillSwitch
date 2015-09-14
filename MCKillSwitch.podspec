Pod::Spec.new do |s|
  s.name     = 'MCKillSwitch'
  s.version  = '0.3.1'
  s.license  = 'BSD 3-Clause'
  s.summary  = 'Stop a version of your app from working, prompting the user to upgrade.'
  s.homepage = 'http://open.mirego.com/'
  s.authors  = { 'Mirego, Inc.' => 'info@mirego.com' }
  s.source   = { :git => 'https://github.com/mirego/MCKillswitch.git', :tag => s.version.to_s }
  s.source_files = 'MCKillSwitch/**/*.{h,m}'
  s.requires_arc = true
  
  s.platform = :ios, '5.0'
end
