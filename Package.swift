// swift-tools-version: 5.7.1
// The swift-tools-version declares the minimum version of Swift required to build this package.

import PackageDescription

let package = Package(
    name: "Feather",
    platforms: [.iOS(.v16), .macOS(.v12)],
    products: [
        .library(
            name: "Feather",
            targets: ["Feather"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor.git", from: "4.76.0"),
    ],
    targets: [
        .target(
            name: "Feather",
            dependencies: [
                .product(name: "Vapor", package: "vapor")
            ],
            path: "Sources",
            exclude: ["../Demo"],
            resources: [.process("Resources")]),
        
        .testTarget(name: "FeatherTests",
                    dependencies: [
                        "Feather",
                        .product(name: "XCTVapor", package: "vapor")],
                    resources: [
                        .copy("user.json"),
                        .copy("user_updated.json"),]
                   ),
    ]
)
