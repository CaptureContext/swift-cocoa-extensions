// swift-tools-version: 6.1

import PackageDescription
import CompilerPluginSupport

let package = Package(
	name: "swift-cocoa-extensions",
	platforms: [
		.macOS(.v11),
		.macCatalyst(.v13),
		.iOS(.v13),
		.tvOS(.v13),
		.watchOS(.v6),
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
			.upToNextMajor(from: "3.5.3")
		),
		.package(
			url: "https://github.com/capturecontext/swift-declarative-configuration.git",
			.upToNextMinor(from: "0.7.1")
		),
		.package(
			url: "https://github.com/capturecontext/swift-foundation-extensions.git",
			.upToNextMinor(from: "0.10.1")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-identified-collections.git",
			.upToNextMajor(from: "1.1.1")
		),
		.package(
			url: "https://github.com/maximkrouk/swift-perception.git",
			exact: "2.0.12"
		),
		.package(
			url: "https://github.com/stackotter/swift-macro-toolkit.git",
			exact: "0.9.0"
		),
		.package(
			url: "https://github.com/swiftlang/swift-syntax.git",
			"509.0.0"..<"605.0.0"
		),
		.package(
			url: "https://github.com/pointfreeco/swift-macro-testing.git",
			.upToNextMinor(from: "0.7.0")
		),
		.package(
			url: "https://github.com/pointfreeco/swift-issue-reporting.git",
			.upToNextMajor(from: "2.1.0")
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
				),
				.product(
					name: "PerceptionCore",
					package: "swift-perception"
				),
			]
		),
		.target(
			name: "CocoaExtensionsMacros",
			dependencies: [
				.target(
					name: "CocoaExtensions",
					condition: nil
				),
				.target(
					name: "CocoaExtensionsMacrosPlugin",
					condition: nil
				),
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
				.product(
					name: "SwiftCompilerPlugin",
					package: "swift-syntax"
				),
				.product(
					name: "SwiftDiagnostics",
					package: "swift-syntax"
				),
				.product(
					name: "SwiftSyntax",
					package: "swift-syntax"
				),
				.product(
					name: "SwiftSyntaxBuilder",
					package: "swift-syntax"
				),
				.product(
					name: "SwiftSyntaxMacros",
					package: "swift-syntax"
				),
			]
		),
		.testTarget(
			name: "CocoaExtensionsTests",
			dependencies: [
				.target(
					name: "CocoaExtensions",
					condition: nil
				),
				.product(
					name: "IssueReportingTestSupport",
					package: "swift-issue-reporting"
				),
			]
		),
		.testTarget(
			name: "CocoaExtensionsMacrosTests",
			dependencies: [
				.target(
					name: "CocoaExtensionsMacros",
					condition: nil
				),
				.product(
					name: "IssueReportingTestSupport",
					package: "swift-issue-reporting"
				),
			]
		),
		.testTarget(
			name: "CocoaExtensionsMacrosPluginTests",
			dependencies: [
				.target(
					name: "CocoaExtensionsMacrosPlugin",
					condition: nil
				),
				.product(
					name: "MacroTesting",
					package: "swift-macro-testing"
				),
				.product(
					name: "IssueReportingTestSupport",
					package: "swift-issue-reporting"
				),
				.product(
					name: "SwiftSyntax",
					package: "swift-syntax"
				),
				.product(
					name: "SwiftSyntaxMacros",
					package: "swift-syntax"
				),
			]
		),
	],
	swiftLanguageModes: [.v6]
)
