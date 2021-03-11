// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "feather-core",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "FeatherCore", targets: ["FeatherCore"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.41.0"),
        .package(url: "https://github.com/vapor/fluent", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/tau", from: "1.0.0"),
        .package(url: "https://github.com/binarybirds/liquid", from: "1.2.0"),
        .package(url: "https://github.com/binarybirds/content-api", from: "1.1.0-rc"),
        .package(url: "https://github.com/binarybirds/view-kit", from: "1.3.0-rc"),
        .package(url: "https://github.com/binarybirds/viper-kit", from: "1.5.0-rc"),
        .package(url: "https://github.com/binarybirds/tau-foundation", from: "1.0.0-rc"),
        /// tests
        .package(url: "https://github.com/binarybirds/spec.git", from: "1.2.0"),
        /// drivers
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.2.0"),
    ],
    targets: [
        .target(name: "FeatherCore", dependencies: [
            .product(name: "Tau", package: "tau"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "ContentApi", package: "content-api"),
            .product(name: "ViewKit", package: "view-kit"),
            .product(name: "Liquid", package: "liquid"),
            .product(name: "ViperKit", package: "viper-kit"),
            .product(name: "TauFoundation", package: "tau-foundation"),
            .product(name: "Vapor", package: "vapor"),
        ], resources: [
            .copy("Bundle"),
        ]),
        .testTarget(name: "FeatherCoreTests", dependencies: [
            .target(name: "FeatherCore"),

            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),

            .product(name: "XCTVapor", package: "vapor"),
            .product(name: "Spec", package: "spec"),
        ])
    ]
)
