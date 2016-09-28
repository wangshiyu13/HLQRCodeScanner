# HLQRCodeScanner

[![CI Status](http://img.shields.io/travis/wangshiyu13/HLQRCodeScanner.svg?style=flat)](https://travis-ci.org/wangshiyu13/HLQRCodeScanner)
[![Version](https://img.shields.io/cocoapods/v/HLQRCodeScanner.svg?style=flat)](http://cocoapods.org/pods/HLQRCodeScanner)
[![License](https://img.shields.io/cocoapods/l/HLQRCodeScanner.svg?style=flat)](http://cocoapods.org/pods/HLQRCodeScanner)
[![Platform](https://img.shields.io/cocoapods/p/HLQRCodeScanner.svg?style=flat)](http://cocoapods.org/pods/HLQRCodeScanner)

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
