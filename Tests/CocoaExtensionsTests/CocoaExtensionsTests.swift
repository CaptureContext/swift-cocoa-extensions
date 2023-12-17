import XCTest
@testable import CocoaExtensions

final class CocoaExtensionsTests: XCTestCase {
	#if os(iOS)
	func testCustomView() throws {
		// Should compile
		class ImageController: CustomCocoaViewController {
			@CustomView
			var customView: UIImageView!
		}
	}
	#endif
}
