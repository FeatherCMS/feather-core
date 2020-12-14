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
        .package(url: "https://github.com/vapor/vapor", from: "4.34.0"),
        .package(url: "https://github.com/vapor/leaf", .exact("4.0.0-tau.1")),
        .package(url: "https://github.com/vapor/leaf-kit", .exact("1.0.0-tau.1.1")),
        .package(url: "https://github.com/vapor/fluent", from: "4.0.0"),
        .package(url: "https://github.com/vapor/jwt", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/content-api", from: "1.1.0-beta"),
        .package(url: "https://github.com/binarybirds/view-kit", from: "1.3.0-beta"),
        .package(url: "https://github.com/binarybirds/liquid", from: "1.2.0-beta"),
        .package(url: "https://github.com/binarybirds/viper-kit", from: "1.5.0-beta"),
        .package(url: "https://github.com/binarybirds/leaf-foundation", from: "1.0.0-beta"),
        /// tests
        .package(url: "https://github.com/binarybirds/spec.git", from: "1.2.0-beta"),
        /// drivers
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.2.0-beta"),
    ],
    targets: [
        .target(name: "FeatherCoreApi"),
        .target(name: "FeatherCore", dependencies: [
            .target(name: "FeatherCoreApi"),

            .product(name: "Leaf", package: "leaf"),
            .product(name: "LeafKit", package: "leaf-kit"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "JWT", package: "jwt"),
            .product(name: "ContentApi", package: "content-api"),
            .product(name: "ViewKit", package: "view-kit"),
            .product(name: "Liquid", package: "liquid"),
            .product(name: "ViperKit", package: "viper-kit"),
            .product(name: "LeafFoundation", package: "leaf-foundation"),
            .product(name: "Vapor", package: "vapor"),
        ], resources: [
            .copy("Bundles"),
        ]),
        .target(name: "Feather", dependencies: [
            .target(name: "FeatherCore"),

            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
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
