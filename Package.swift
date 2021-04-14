// swift-tools-version:5.3
import PackageDescription

let package = Package(
    name: "feather-core",
    platforms: [
       .macOS(.v10_15)
    ],
    products: [
        .library(name: "FeatherCore", targets: ["FeatherCore"]),
        .library(name: "FeatherApi", targets: ["FeatherApi"]),
        .executable(name: "FeatherCli", targets: ["FeatherCli"]),
        .executable(name: "FeatherExample", targets: ["FeatherExample"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.41.0"),
        .package(url: "https://github.com/vapor/fluent", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/tau", from: "1.0.0"),
        .package(url: "https://github.com/binarybirds/liquid", from: "1.2.0"),
        .package(url: "https://github.com/binarybirds/vapor-hooks", from: "1.0.0"),
        /// tests
        .package(url: "https://github.com/binarybirds/spec.git", from: "1.2.0"),
        /// drivers
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.2.0"),
    ],
    targets: [
        .target(name: "FeatherExample", dependencies: [
            .target(name: "FeatherCore"),
            
            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
        ], resources: [
            .copy("Modules/README.md"),
        ]),
        .target(name: "FeatherCli", dependencies: [
            .target(name: "FeatherCore")
        ]),
        .target(name: "FeatherApi"),
        .target(name: "FeatherCore", dependencies: [
            .product(name: "Tau", package: "tau"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "Liquid", package: "liquid"),
            .product(name: "Vapor", package: "vapor"),
            .product(name: "VaporHooks", package: "vapor-hooks"),
            .target(name: "FeatherApi")
        ], resources: [
            .copy("_SystemModule/Bundle"),
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
