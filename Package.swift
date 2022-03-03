// swift-tools-version:5.5
import PackageDescription

let package = Package(
    name: "feather-core",
    platforms: [
       .macOS(.v12),
    ],
    products: [
        .library(name: "FeatherRestKit", targets: ["FeatherRestKit"]),
        .library(name: "Feather", targets: ["Feather"]),
    ],
    dependencies: [
        .package(url: "https://github.com/vapor/vapor", from: "4.55.0"),
        .package(url: "https://github.com/vapor/fluent", from: "4.4.0"),
        .package(url: "https://github.com/binarybirds/liquid", from: "1.3.0"),
        .package(url: "https://github.com/binarybirds/mail", from: "0.0.1"),
        .package(url: "https://github.com/binarybirds/swift-html", from: "1.6.0"),
        .package(url: "https://github.com/binarybirds/spec", from: "1.2.0"),
        .package(url: "https://github.com/vapor/fluent-sqlite-driver", from: "4.0.0"),
        .package(url: "https://github.com/binarybirds/liquid-local-driver", from: "1.3.0"),
        .package(url: "https://github.com/binarybirds/mail-aws-driver", from: "0.0.1"),
    ],
    targets: [
        // MARK: - app
        .executableTarget(name: "FeatherApp", dependencies: [
            .target(name: "Feather"),

            .product(name: "FluentSQLiteDriver", package: "fluent-sqlite-driver"),
            .product(name: "LiquidLocalDriver", package: "liquid-local-driver"),
            .product(name: "MailAwsDriver", package: "mail-aws-driver"),
        ]),
        
        // MARK: - core
        .target(name: "FeatherRestKit", dependencies: []),

        .target(name: "Feather", dependencies: [
            .target(name: "FeatherRestKit"),
            .target(name: "FeatherIcons"),

            .product(name: "Vapor", package: "vapor"),
            .product(name: "Fluent", package: "fluent"),
            .product(name: "Liquid", package: "liquid"),
            .product(name: "Mail", package: "mail"),
            .product(name: "SwiftHtml", package: "swift-html"),
            .product(name: "SwiftSvg", package: "swift-html"),
            .product(name: "SwiftRss", package: "swift-html"),
            .product(name: "SwiftSitemap", package: "swift-html"),
        ], resources: [
            .copy("Modules/System/Bundle"),
        ]),
                
        // MARK: - icons
        
        .target(name: "FeatherIcons", dependencies: [
            .product(name: "SwiftSvg", package: "swift-html"),
        ]),
        
        // MARK: - XCTFeather
    
        .target(name: "XCTFeather", dependencies: [
            .target(name: "Feather"),
            .product(name: "Spec", package: "spec"),
        ]),
        
        // MARK: - test targets
        
        .testTarget(name: "FeatherTests", dependencies: [
            .target(name: "Feather"),
        ]),
//        .testTarget(name: "FeatherCoreSdkTests", dependencies: [
//            .target(name: "FeatherCoreSdk"),
//        ]),

        .testTarget(name: "XCTFeatherTests", dependencies: [
            .target(name: "XCTFeather"),
        ])
    ]
)

