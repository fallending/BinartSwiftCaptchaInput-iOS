# BinartSwiftCaptchaInput

[![CI Status](https://img.shields.io/travis/fallending/BinartSwiftCaptchaInput.svg?style=flat)](https://travis-ci.org/fallending/BinartSwiftCaptchaInput)
[![Version](https://img.shields.io/cocoapods/v/BinartSwiftCaptchaInput.svg?style=flat)](https://cocoapods.org/pods/BinartSwiftCaptchaInput)
[![License](https://img.shields.io/cocoapods/l/BinartSwiftCaptchaInput.svg?style=flat)](https://cocoapods.org/pods/BinartSwiftCaptchaInput)
[![Platform](https://img.shields.io/cocoapods/p/BinartSwiftCaptchaInput.svg?style=flat)](https://cocoapods.org/pods/BinartSwiftCaptchaInput)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

### 有趣的事情

自动填充的时候，打印日志：

```
2020-10-10 18:01:07.207145+0800 BinartSwiftCaptchaInput_Example[92708:4857658] 变更内容：
2020-10-10 18:01:07.224230+0800 BinartSwiftCaptchaInput_Example[92708:4857658] 变更内容：
2020-10-10 18:01:07.228281+0800 BinartSwiftCaptchaInput_Example[92708:4857658] 变更内容：4
2020-10-10 18:01:07.263527+0800 BinartSwiftCaptchaInput_Example[92708:4857658] 变更内容：7
2020-10-10 18:01:07.281448+0800 BinartSwiftCaptchaInput_Example[92708:4857658] 变更内容：0
2020-10-10 18:01:07.297135+0800 BinartSwiftCaptchaInput_Example[92708:4857658] 变更内容：4
2020-10-10 18:01:07.312114+0800 BinartSwiftCaptchaInput_Example[92708:4857658] 变更内容：5
2020-10-10 18:01:07.325937+0800 BinartSwiftCaptchaInput_Example[92708:4857658] 变更内容：4
```

```
2020-10-10 18:03:23.065897+0800 鸣角[92730:4858663] 变更内容：549492
2020-10-10 18:03:23.066889+0800 鸣角[92730:4858663] 变更内容：
2020-10-10 18:03:23.067807+0800 鸣角[92730:4858663] 变更内容：5
2020-10-10 18:03:23.113483+0800 鸣角[92730:4858663] 变更内容：4
2020-10-10 18:03:23.138162+0800 鸣角[92730:4858663] 变更内容：9
2020-10-10 18:03:23.157535+0800 鸣角[92730:4858663] 变更内容：4
2020-10-10 18:03:23.174510+0800 鸣角[92730:4858663] 变更内容：9
2020-10-10 18:03:23.189494+0800 鸣角[92730:4858663] 变更内容：2
```

有上面可以看出，第二份打印中，会先收到一份。目前的处理方式是屏蔽第一次的全量验证码输入，还没有更好的解决方法。


待研究～～～～～

## Requirements

## Installation

BinartSwiftCaptchaInput is available through [CocoaPods](https://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'BinartSwiftCaptchaInput'
```

## Author

fallending, fengzilijie@qq.com

## License

BinartSwiftCaptchaInput is available under the MIT license. See the LICENSE file for more info.
