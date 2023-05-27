// swift-tools-version:5.5
import PackageDescription

let package = Package(
	name: "feather-core",
	platforms: [
		.macOS(.v12),
	],
	products: [
		.library(name: "FeatherCore", targets: ["FeatherCore"]),
	],
	dependencies: [
		.package(url: "https://github.com/vapor/vapor", from: "4.70.0"),
		.package(url: "https://github.com/vapor/fluent", from: "4.4.0"),
		.package(url: "https://github.com/binarybirds/liquid", from: "1.3.0"),
		.package(url: "https://github.com/binarybirds/mail", from: "0.0.1"),
		.package(url: "https://github.com/binarybirds/swift-html", from: "1.7.0"),
//		.package(path: "../feather-objects"),
//		.package(path: "../feather-icons"),
		.package(url: "https://github.com/binarybirds/spec", from: "1.2.0"),
		.package(url: "https://github.com/Rando-Coderissian/feather-objects", .branch("test-refactor-modules")),
		//		.package(url: "https://github.com/feathercms/feather-objects", .branch("main")),
		.package(url: "https://github.com/feathercms/feather-icons", .branch("main")),

	],
	targets: [
		.target(name: "FeatherCore", dependencies: [
			.product(name: "Vapor", package: "vapor"),
			.product(name: "Fluent", package: "fluent"),
			.product(name: "Liquid", package: "liquid"),
			.product(name: "Mail", package: "mail"),
			.product(name: "SwiftHtml", package: "swift-html"),
			.product(name: "SwiftSvg", package: "swift-html"),
			.product(name: "SwiftRss", package: "swift-html"),
			.product(name: "SwiftSitemap", package: "swift-html"),
			.product(name: "FeatherIcons", package: "feather-icons"),
			.product(name: "FeatherObjects", package: "feather-objects"),
		], resources: [
			.copy("Modules/System/Bundle"),
		]),
		
			.target(name: "XCTFeather", dependencies: [
				.target(name: "FeatherCore"),
				.product(name: "Spec", package: "spec"),
			
			]),
//		.executableTarget(name: "Run", dependencies: ["FeatherCore"]),
		
		// MARK: - test targets
		
			.testTarget(name: "FeatherTests", dependencies: [
				.target(name: "FeatherCore"),
			]),
		.testTarget(name: "XCTFeatherTests", dependencies: [
			.target(name: "XCTFeather"),
		])
	]
)

