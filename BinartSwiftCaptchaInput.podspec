#
# Be sure to run `pod lib lint BinartSwiftCaptchaInput.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BinartSwiftCaptchaInput'
  s.version          = '0.1.4'
  s.summary          = 'Captcha input view for iOS, Swift.'
  s.description      = <<-DESC
Captcha input view for iOS, Swift. Pity, it's still experimental.
                       DESC

  s.homepage         = 'https://github.com/fallending/BinartSwiftCaptchaInput-iOS'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'fallending' => 'fengzilijie@qq.com' }
  s.source           = { :git => 'https://github.com/fallending/BinartSwiftCaptchaInput-iOS.git', :tag => s.version.to_s }

  s.platform        = :ios
  s.swift_version   = '5.0'
  s.ios.deployment_target = '9.0'

  s.source_files = 'BinartSwiftCaptchaInput/Classes/*'
  s.frameworks = 'UIKit'

end
