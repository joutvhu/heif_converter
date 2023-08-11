#
# To learn more about a Podspec see http://guides.cocoapods.org/syntax/podspec.html.
# Run `pod lib lint heif_converter.podspec` to validate before publishing.
#
Pod::Spec.new do |s|
  s.name             = 'heif_converter'
  s.version          = '1.0.0'
  s.summary          = 'Flutter plugin to convert HEIC/HEIF file to PNG/JPEG image.'
  s.description      = <<-DESC
A new Flutter project.
                       DESC
  s.homepage         = 'https://github.com/joutvhu/heif_converter'
  s.license          = { :file => '../LICENSE' }
  s.author           = { 'joutvhu (Giao Ho)' => 'joutvhu@gmail.com' }
  s.source           = { :path => '.' }
  s.source_files = 'Classes/**/*'
  s.dependency 'Flutter'
  s.platform = :ios, '11.0'

  # Flutter.framework does not contain a i386 slice.
  s.pod_target_xcconfig = { 'DEFINES_MODULE' => 'YES', 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'i386' }
  s.swift_version = '5.0'
end
