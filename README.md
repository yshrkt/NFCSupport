# NFCSupport
![Xcode](https://img.shields.io/badge/Xcode-10.0-brightgreen.svg)
![Swift](https://img.shields.io/badge/Swift-4.2-brightgreen.svg)
![platforms](https://img.shields.io/badge/platforms-iOS-333333.svg)
![Travis CI](https://travis-ci.org/yshrkt/NFCSupport.svg?branch=master)

This is support library for handling NFC NDEF Records.

## Environment

* iOS11
* Swift 4.2

## Supported record type

* Text Record
* URI Record
* Smart Poster Record

## Usage

```swift
guard let result = try? NFCNDEFWellknown.parse(type: record.type, payload: record.payload) else {
    print("can not parse record")
    return
}

switch result {
case let .text(record):
    print("text: \(record.text)")
case let .uri(record):
    print("uri: \(record.uri?.absoluteString ?? "")")
case let .smartPoster(record):
    print("title: \(record.titleRecords.first?.text ?? "") uri: \(record.uri?.absoluteString ?? "")")
case let .unsupported(type):
    print("unsupported record type (\(type))")
}
```

## Installation

### Carthage

To install it, simply add the following line to your `Cartfile`:

```
github "yshrkt/NFCSupport"
```

### CocoaPods

To install it, simply add the following line to your `Podfile`:

```
pod "NFCSupport"
```

## Licence

NFCSupport is released under the MIT license. [See LICENSE](https://github.com/yshrkt/NFCSupport/blob/master/LICENSE) for details.

## Author

[yshrkt](https://github.com/yshrkt)
