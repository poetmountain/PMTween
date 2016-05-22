Pod::Spec.new do |s|
  s.name = 'PMTween'
  s.version = '1.3.6'
  s.license = { :type => 'MIT' }
  s.summary = 'An elegant and flexible tweening library for iOS.'
  s.ios.deployment_target = '7.0'
  s.tvos.deployment_target = '9.0'
  s.ios.frameworks = 'CoreGraphics'
  s.tvos.frameworks = 'CoreGraphics'
  s.homepage = 'https://github.com/poetmountain/PMTween'
  s.social_media_url = 'https://twitter.com/petsound'
  s.authors = { 'Brett Walker' => 'brett@brettwalker.net' }
  s.source = { :git => 'https://github.com/poetmountain/PMTween.git', :tag => "#{s.version}" }
  s.ios.source_files = 'Classes/**/*.{h,m}'
  s.tvos.source_files = 'Classes/**/*.{h,m}'
  s.requires_arc = true
end