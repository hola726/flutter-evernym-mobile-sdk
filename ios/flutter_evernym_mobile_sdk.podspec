#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint flutter_evernym_mobile_sdk.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'flutter_evernym_mobile_sdk'
  s.version          = '0.0.1'
  s.summary          = 'Evernym Mobile SDK Flutter Library'
  s.description      = <<-DESC
Evernym Mobile SDK Flutter Library
                       DESC
  s.homepage         = 'http://example.com'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'Your Company' => 'wodbs720@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.dependency 'vcx','0.0.227'
  s.platform = :ios, '13.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
