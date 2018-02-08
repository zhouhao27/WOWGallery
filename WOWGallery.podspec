#
# Be sure to run `pod lib lint WOWGallery.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'WOWGallery'
  s.version          = '0.1.0'
  s.summary          = 'PhotoGallery library.'

  s.description      = <<-DESC
Similar to iOS photo album. But you can select different data source.
                       DESC

  s.homepage         = 'https://github.com/zhouhao27/WOWGallery'
  # s.screenshots     = 'www.example.com/screenshots_1', 'www.example.com/screenshots_2'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhouhao27' => 'zhou.hao.27@gmail.com' }
  s.source           = { :git => 'https://github.com/zhouhao27/WOWGallery.git', :tag => s.version.to_s }
  # s.social_media_url = 'https://twitter.com/<TWITTER_USERNAME>'

  s.ios.deployment_target = '8.0'

  s.source_files = 'WOWGallery/Classes/**/*'
  s.resources    = 'WOWGallery/Assets/WOWGallery.bundle'

  # s.public_header_files = 'Pod/Classes/**/*.h'
  # s.frameworks = 'UIKit', 'MapKit'
  # s.dependency 'AFNetworking', '~> 2.3'
end
