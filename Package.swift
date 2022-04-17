// swift-tools-version:5.5

import PackageDescription

let package = Package(
  name: "swift-cocoa-extensions",
  platforms: [
    .macOS(.v10_15),
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
      name: "cocoa-aliases",
      url: "https://github.com/capturecontext/cocoa-aliases.git",
      .upToNextMajor(from: "2.0.4")
    ),
    .package(
      name: "swift-declarative-configuration",
      url: "https://github.com/capturecontext/swift-declarative-configuration.git",
      .upToNextMinor(from: "0.3.0")
    ),
    .package(
      name: "swift-foundation-extensions",
      url: "https://github.com/capturecontext/swift-foundation-extensions.git",
      .branch("main")
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
      ]
    ),
  ]
)
