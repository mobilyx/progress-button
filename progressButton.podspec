
Pod::Spec.new do |s|
  s.name             = 'progressButton'
  s.version          = '1.0.0'
  s.summary          = 'Progress Button.' 
  s.homepage         = 'https://github.com/mobilyx/progress-button-ios'
  # s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'mobilyx' => 'https://github.com/mobilyx/' }
  s.source           = { :git => 'https://github.com/mobilyx/progress-button-ios.git', :tag => s.version.to_s }
 
  # s.source_files = 'ProgressButton/**/*.{swift}'
  s.source_files = 'ProgressButton/**/*.{h,m,swift,xib}'
  s.resources    = 'ProgressButton/Artworks.xcassets'
  s.requires_arc = true
  s.ios.deployment_target = '13.0'
  s.swift_versions = '5.0'
  s.static_framework = true
 
end