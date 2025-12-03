// swift-tools-version: 5.9
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "CoverySDK",
    platforms: [
        .iOS(.v15)
    ],
    products: [
        .library(
            name: "CoverySDK",
            targets: [ "CoverySDK" ]),
    ],
    targets: [
        .binaryTarget(name: "CoverySDK", path: "CoverySDK.xcframework"),
    ],
    swiftLanguageVersions: [.v5]
)
