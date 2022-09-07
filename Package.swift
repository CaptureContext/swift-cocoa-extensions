// swift-tools-version:5.6

import PackageDescription

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
      .upToNextMinor(from: "0.3.0")
    ),
    .package(
      url: "https://github.com/capturecontext/swift-foundation-extensions.git",
      .upToNextMinor(from: "0.1.0")
    ),
    .package(
      url: "https://github.com/pointfreeco/swift-identified-collections.git",
      .upToNextMinor(from: "0.3.2")
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
  ]
)
