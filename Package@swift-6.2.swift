// swift-tools-version: 6.2

import PackageDescription
import CompilerPluginSupport

let package = Package(
	name: "swift-cocoa-extensions",
	platforms: [
		.macOS(.v11),
		.macCatalyst(.v13),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6)
	],
	products: [
		.library(
			name: "CocoaExtensions",
			targets: ["CocoaExtensions"]
		),
		.library(
			name: "CocoaExtensionsMacros",
			targets: ["CocoaExtensionsMacros"]
		),
	],
	dependencies: [
		.package(
			url: "https://github.com/capturecontext/cocoa-aliases.git",
			.upToNextMajor(from: "3.0.0")
		),
		.package(
			url: "https://github.com/capturecontext/swift-declarative-configuration.git",
			.upToNextMinor(from: "0.5.0")
		),
		.package(
			url: "https://github.com/capturecontext/swift-foundation-extensions.git",
			.upToNextMinor(from: "0.6.0")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-identified-collections.git",
			.upToNextMajor(from: "1.0.0")
		),
		.package(
			url: "https://github.com/stackotter/swift-macro-toolkit.git",
			.upToNextMinor(from: "0.8.0")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-macro-testing.git",
			.upToNextMinor(from: "0.6.0")
		),
		.package(
			url: "https://github.com/pointfreeco/xctest-dynamic-overlay.git",
			.upToNextMajor(from: "1.8.0")
		),
	],
	targets: [
		.target(
			name: "CocoaExtensions",
			dependencies: [
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
		.target(
			name: "CocoaExtensionsMacros",
			dependencies: [
				.target(name: "CocoaExtensions"),
				.target(name: "CocoaExtensionsMacrosPlugin"),
				.product(
					name: "FoundationExtensionsMacros",
					package: "swift-foundation-extensions"
				),
			]
		),
		.macro(
			name: "CocoaExtensionsMacrosPlugin",
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
				.target(name: "CocoaExtensions"),
				.product(name: "IssueReportingTestSupport", package: "xctest-dynamic-overlay"),
			]
		),
		.testTarget(
			name: "CocoaExtensionsMacrosTests",
			dependencies: [
				.target(name: "CocoaExtensionsMacros"),
				.product(name: "IssueReportingTestSupport", package: "xctest-dynamic-overlay"),
			]
		),
		.testTarget(
			name: "CocoaExtensionsMacrosPluginTests",
			dependencies: [
				.target(name: "CocoaExtensionsMacrosPlugin"),
				.product(name: "MacroTesting", package: "swift-macro-testing"),
				.product(name: "IssueReportingTestSupport", package: "xctest-dynamic-overlay"),
			]
		),
	],
	swiftLanguageModes: [.v6]
)
