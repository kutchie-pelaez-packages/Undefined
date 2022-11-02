// swift-tools-version:5.7

import PackageDescription

let package = Package(
    name: "Undefined",
    platforms: [.iOS(.v16)],
    products: [
        .library(name: "Undefined", targets: ["Undefined"])
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.0.0")
    ],
    targets: [
        .target(name: "Undefined", dependencies: [
            .product(name: "Logging", package: "swift-log")
        ], path: "Sources")
    ]
)
