// swift-tools-version: 5.9

import PackageDescription
import CompilerPluginSupport

let package = Package(
	name: "swift-cocoa-extensions",
	platforms: [
		.macOS(.v11),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "CocoaExtensions",
			targets: ["CocoaExtensions"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/capturecontext/cocoa-aliases.git",
			.upToNextMajor(from: "2.0.5")
		),
		.package(
			url: "https://github.com/capturecontext/swift-declarative-configuration.git",
			.upToNextMinor(from: "0.3.3")
		),
		.package(
			url: "https://github.com/capturecontext/swift-foundation-extensions.git",
			.upToNextMinor(from: "0.4.0")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-identified-collections.git",
			.upToNextMajor(from: "1.0.0")
		),
		.package(
			url: "https://github.com/stackotter/swift-macro-toolkit.git",
			.upToNextMinor(from: "0.3.0")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-macro-testing.git",
			.upToNextMinor(from: "0.2.2")
		)
	],
	targets: [
		.target(
			name: "CocoaExtensions",
			dependencies: [
				.target(name: "CocoaExtensionsMacros"),
				.product(
					name: "CocoaAliases",
					package: "cocoa-aliases"
				),
				.product(
					name: "DeclarativeConfiguration",
					package: "swift-declarative-configuration"
				),
				.product(
					name: "FoundationExtensions",
					package: "swift-foundation-extensions"
				),
				.product(
					name: "IdentifiedCollections",
					package: "swift-identified-collections"
				)
			]
		),
		.macro(
			name: "CocoaExtensionsMacros",
			dependencies: [
				.product(
					name: "MacroToolkit",
					package: "swift-macro-toolkit"
				),
			]
		),
		.testTarget(
			name: "CocoaExtensionsTests",
			dependencies: [
				.target(name: "CocoaExtensions")
			]
		),
		.testTarget(
			name: "CocoaExtensionsMacrosTests",
			dependencies: [
				.target(name: "CocoaExtensionsMacros"),
				.product(name: "MacroTesting", package: "swift-macro-testing"),
			]
		),
	]
)
