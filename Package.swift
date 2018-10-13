// swift-tools-version:4.2

import PackageDescription

let package = Package(
    name: "NFCSupport",
    products: [
        .library(name: "NFCSupport", type: .dynamic, targets: ["NFCSupport"])
        ],
    dependencies: [],
    targets: [
        .target(
            name: "NFCSupport",
            dependencies: []
        ),
    ],
    swiftLanguageVersions: [.v4, .v4_2]
)
