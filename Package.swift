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
            dependencies: [],
            path: "Sources"
        ),
        .testTarget(
            name: "NFCSupportTests",
            dependencies: ["NFCSupport"],
            path: "Tests"
        )
    ],
    swiftLanguageVersions: [.v5_2]
)
