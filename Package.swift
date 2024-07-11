// swift-tools-version: 5.10
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "SwiftLogBack",
    products: [
        // Products define the executables and libraries a package produces, making them visible to other packages.
        .library(
            name: "SwiftLogBack",
            targets: ["SwiftLogBack"]),
    ],
    dependencies: [
        .package(url: "https://github.com/apple/swift-log.git", from: "1.6.1"),
        .package(url: "https://github.com/apple/swift-nio.git", from: "2.68.0"),
    ],
    targets: [
        // Targets are the basic building blocks of a package, defining a module or a test suite.
        // Targets can depend on other targets in this package and products from dependencies.
        .target(
            name: "SwiftLogBack",
            dependencies: [
                .product(name: "Logging", package: "swift-log"),
                .product(name: "NIOConcurrencyHelpers", package: "swift-nio"),
            ]
        ),
        .testTarget(
            name: "SwiftLogBackTests",
            dependencies: ["SwiftLogBack"]),
    ]
)
