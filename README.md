# HLQRCodeScanner
[![License MIT](https://img.shields.io/badge/license-MIT-green.svg?style=flat)](https://github.com/wangshiyu13/HLQRCodeScanner/blob/master/LICENSE)
[![CI Status](https://img.shields.io/badge/build-1.0.1-brightgreen.svg)](https://travis-ci.org/wangshiyu13/HLQRCodeScanner)
[![CocoaPods](https://img.shields.io/badge/platform-iOS-lightgrey.svg)](http://cocoapods.org/?q= HLQRCodeScanner)
[![Support](https://img.shields.io/badge/support-iOS%208%2B-blue.svg)](https://www.apple.com/nl/ios/)

## Example

* 导入框架

```swift
import HLQRCodeScanner
```

* 打开扫描控制器，扫描及完成回调

```swift


let scanner = HLQRCodeScanner.scanner { (result) in
debugPrint(result)
}
showDetailViewController(scanner, sender: nil)
```

* 生成二维码图片

```swift
let cardName = "wangshiyu13"
let avatar = UIImage(named: "avatar")

self.imageView.image = HLQRCodeScanner.createQRCodeImage(cardName, avatar: avatar, scale: 0.2)
```


## Requirements

This library requires iOS 8.0+ and Xcode 7.0+.

## Installation

HLQRCodeScanner is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod "HLQRCodeScanner"
```

## Author

wangshiyu13, wangshiyu13@163.com

## License

HLQRCodeScanner is available under the MIT license. See the LICENSE file for more info.
