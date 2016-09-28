
Pod::Spec.new do |s|
  s.name             = 'HLQRCodeScanner'
  s.version          = '1.0.1'
  s.summary          = '包含 UI 界面的轻量级二维码扫描及生成框架'
  s.homepage         = 'https://github.com/wangshiyu13/HLQRCodeScanner'
  s.license          = { :type => 'MIT', :file => 'LICENSE' }
  s.author           = { 'wangshiyu13' => 'wangshiyu13@163.com' }
  s.source           = { :git => 'https://github.com/wangshiyu13/HLQRCodeScanner.git', :tag => s.version.to_s }
  s.ios.deployment_target = '8.0'
  s.source_files = 'HLQRCodeScanner/Classes/**/*'
  s.resources = 'HLQRCodeScanner/Assets/HLQRCodeScanner.bundle'
  s.frameworks = 'AVFoundation'
end
