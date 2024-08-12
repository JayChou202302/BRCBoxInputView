#
# Be sure to run `pod lib lint BRCBoxInputView.podspec' to ensure this is a
# valid spec before submitting.
#
# Any lines starting with a # are optional, but their use is encouraged
# To learn more about a Podspec see https://guides.cocoapods.org/syntax/podspec.html
#

Pod::Spec.new do |s|
  s.name             = 'BRCBoxInputView'
  s.version          = '1.1.0'
  s.summary          = 'BRCBoxInputView is a customizable input view that supports various text input customizations and conforms to the UITextInput protocol.'
  
  s.description      = "BRCBoxInputView is a customizable input view that conforms to the UITextInput protocol.It offers various text input customizations, including keyboard settings, caret styles,box alignment, and input length constraints. The view supports menu actions like copy,paste, cut, and delete, and includes features for handling custom input events and first responder status."
  
  s.homepage         = 'https://github.com/JayChou202302/BRCBoxInputView'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'zhixiongsun' => 'sunzhixiong91@gmail.com' }
  s.source           = { :git => 'https://github.com/JayChou202302/BRCBoxInputView.git', :tag => s.version.to_s }
  s.ios.deployment_target = '13.0'
  s.source_files = 'BRCBoxInputView/Classes/**/*'
  s.frameworks = 'UIKit','Foundation'
end
