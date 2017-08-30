# NFCSupport
![Xcode](https://img.shields.io/badge/Xcode-9.0-brightgreen.svg)
![Swift](https://img.shields.io/badge/Swift-3.2-brightgreen.svg)
![platforms](https://img.shields.io/badge/platforms-iOS-333333.svg)
![Travis CI](https://travis-ci.org/yshrkt/NFCSupport.svg?branch=master)

This is support library for handling NFC NDEF Records.

## Environment

* iOS11
* Swift 3.2

## Supported record type

* Text Record
* URI Record
* Smart Poster Record

## Usage

* Text Record
```swift
let record: NFCNDEFPayload = getRecord() // get record using CoreNFC
let recordType = NFCNDEFWellknown.RecordType(rawData: record.type)
if recordType == .text {
    let textRecord: NFCNDEFWellknown.TextRecord? = try? recordType.parse(with: record.payload)
    if let text = textRecord?.text {
      print("text: \(text)")
    }
}
```
* URI Record
```swift
if recordType == .uri {
    let uriRecord: NFCNDEFWellknown.URIRecord? = try? recordType.parse(with: record.payload)
    if let uri = uriRecord?.uri {
      print("uri: \(uri.absoluteString)")
    }
}
```

* Smart Poster Record
```swift
if recordType == .smartPoster {
    let spRecord: NFCNDEFWellknown.SmartPosterRecord? = try? recordType.parse(with: record.payload)
    if let uri = spRecord?.uri {
      print("uri: \(uri.absoluteString)")
    }
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
