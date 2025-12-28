# swift-cocoa-extensions

[![CI](https://github.com/CaptureContext/swift-cocoa-extensions/actions/workflows/ci.yml/badge.svg)](https://github.com/CaptureContext/swift-cocoa-extensions/actions/workflows/ci.yml) [![Swift 6.2](https://img.shields.io/badge/Swift-6.2-ED523F.svg?style=flat)](https://swift.org/download/) ![Platforms](https://img.shields.io/badge/Platforms-iOS_13_|_macOS_10.15_|_Catalyst_13_|_tvOS_14_|_watchOS_7-ED523F.svg?style=flat) [![@maximkrouk](https://img.shields.io/badge/Contact-@capturecontext-1DA1F2.svg?style=flat&logo=twitter)](https://twitter.com/capture_context) 

Standard extensions for Cocoa

> The package is in beta (feel free suggest your improvements [here](https://github.com/capturecontext/swift-cocoa-extensions/discussions/1))
>
> But we do respect semantic versioning 😉


## Installation

### Basic

You can add CocoaExtensions to an Xcode project by adding it as a package dependency.

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swift-cocoa-extensions.git"`](https://github.com/capturecontext/swift-cocoa-extensions.git) into the package repository URL text field
3. Choose products you need to link them to your project.

### Recommended

If you use SwiftPM for your project, you can add StandardExtensions to your package file.

```swift
.package(
  name: "swift-cocoa-extensions",
  url: "https://github.com/capturecontext/swift-cocoa-extensions.git", 
  .upToNextMinor(from: "0.5.0-alpha.1")
)
```

Do not forget about target dependencies:

```swift
.product(
  name: "CocoaExtensions", 
  package: "swift-cocoa-extensions"
)
```

```swift
.product(
  name: "CocoaExtensionsMacros", 
  package: "swift-cocoa-extensions"
)
```



## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.
