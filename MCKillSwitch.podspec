Pod::Spec.new do |s|
  s.name     = 'MCKillSwitch'
  s.version  = '1.3'
  s.license  = 'BSD 3-Clause'
  s.summary  = 'Stop a version of your app from working, prompting the user to upgrade.'
  s.homepage = 'http://open.mirego.com/'
  s.authors  = { 'Mirego, Inc.' => 'info@mirego.com' }
  s.source   = { :git => 'git@github.com:mirego/MCKillSwitch.git', :tag => s.version.to_s }
  s.source_files = 'MCKillSwitch/**/*.{h,m}'
  s.requires_arc = true
  
  s.ios.deployment_target = '6.0'
  # s.watchos.deployment_target = '2.0'
  s.tvos.deployment_target = '9.0'
end
