# swift-cocoa-extensions

[![CI](https://github.com/capturecontext/swift-cocoa-extensions/actions/workflows/ci.yml/badge.svg)](https://github.com/capturecontext/swift-cocoa-extensions/actions/workflows/ci.yml) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapturecontext%2Fswift-cocoa-extensions%2Fbadge%3Ftype%3Dswift-versions)](https://swiftpackageindex.com/capturecontext/swift-cocoa-extensions) [![](https://img.shields.io/endpoint?url=https%3A%2F%2Fswiftpackageindex.com%2Fapi%2Fpackages%2Fcapturecontext%2Fswift-cocoa-extensions%2Fbadge%3Ftype%3Dplatforms)](https://swiftpackageindex.com/capturecontext/swift-cocoa-extensions)

Standard extensions for Cocoa

## Table of contents

- [Usage](#usage)
- [Installation](#installation)
- [License](#license)

## Usage

> [!NOTE]
>
> _The package is in beta (feel free suggest your improvements [here](https://github.com/capturecontext/swift-cocoa-extensions/discussions/1))
> But we do respect semantic versioning_ 😉

## Installation

### Basic

You can add `swift-cocoa-extensions` to an Xcode project by adding it as a package dependency

1. From the **File** menu, select **Swift Packages › Add Package Dependency…**
2. Enter [`"https://github.com/capturecontext/swift-cocoa-extensions"`](https://github.com/capturecontext/swift-cocoa-extensions) into the package repository URL text field
3. Choose products you need to link to your project.

### Recommended

If you use SwiftPM for your project structure, add `swift-cocoa-extensions` dependency to your package file

```swift
.package(
  url: "https://github.com/capturecontext/swift-cocoa-extensions.git", 
  .upToNextMinor("0.5.0")
)
```

Do not forget about target dependencies

```swift
.product(
  name: "<#Product#>", 
  package: "swift-cocoa-extensions"
)
```

> [!NOTE]
>
> _The package is compatible with non-Apple platforms, however it uses conditional compilation, so **APIs are only available on Apple platforms**_

## License

This library is released under the MIT license. See [LICENSE](LICENSE) for details.## Installation
