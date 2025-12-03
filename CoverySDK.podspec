#
# Be sure to run `pod lib lint CoverySDK.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'CoverySDK'
  s.version          = '1.0.0'
  s.summary          = 'CoverySDK is a library to simplify of passing KYC procedure.'

# This description is used to generate tags and improve search results.
#   * Think: What does it do? Why did you write it? What is the focus?
#   * Try to keep it short, snappy and to the point.
#   * Write the description between the DESC delimiters below.
#   * Finally, don't worry about the indent, CocoaPods strips it!

  s.description      = <<-DESC
CoverySDK is a library to simplify of passing KYC procedure.
It helps to pass selfie KYC and document KYC.
                       DESC

  s.homepage         = 'https://github.com/coverydevteam/ios-sdk'
  s.license          = { :type => 'MIT' }
  s.author           = { 'CoverySDK' => 'Covery AI Limited' }
  s.source           = { :path => 'CoverySDK.xcframework', :tag => s.version.to_s }

  s.swift_version = '5.9'
  s.platform     = :ios, "15.5"

  s.vendored_frameworks = 'CoverySDK.xcframework'
  s.user_target_xcconfig = { 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'VALID_ARCHS' => 'x86_64 arm64'
  }
  s.pod_target_xcconfig = { 
    'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64',
    'VALID_ARCHS' => 'x86_64 arm64'
  }
end
