// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "feather-core",
    platforms: [
       .macOS(.v12),
    ],
    products: [
        .library(name: "FeatherCoreApi", targets: ["FeatherCoreApi"]),
        .library(name: "FeatherCoreSdk", targets: ["FeatherCoreSdk"]),
        .library(name: "FeatherCore", targets: ["FeatherCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.54.0"),
        .package(url: "https://github.com/vapor/fluent", from: "4.4.0"),
        .package(url: "https://github.com/binarybirds/liquid", from: "1.3.0"),
        .package(url: "https://github.com/binarybirds/swift-html", from: "1.2.0"),
//        .package(path: "../swift-html"),
        .package(url: "https://github.com/binarybirds/swift-css", from: "1.0.0"),
    ],
    targets: [
        .target(name: "FeatherCoreApi", dependencies: []),
        .target(name: "FeatherCoreSdk", dependencies: [
            .target(name: "FeatherCoreApi"),
        ]),
        .target(name: "FeatherCore", dependencies: [
            .target(name: "FeatherCoreApi"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "Liquid", package: "liquid"),
            .product(name: "SwiftHtml", package: "swift-html"),
            .product(name: "SwiftSvg", package: "swift-html"),
            .product(name: "SwiftRss", package: "swift-html"),
            .product(name: "SwiftSitemap", package: "swift-html"),
            .product(name: "SwiftCss", package: "swift-css"),
        ], resources: [
            .copy("Bundle"),
        ]),
        .testTarget(name: "FeatherCoreTests", dependencies: [
            .target(name: "FeatherCore"),
        ]),
        .testTarget(name: "FeatherCoreSdkTests", dependencies: [
            .target(name: "FeatherCoreSdk"),
        ])
    ]
)
