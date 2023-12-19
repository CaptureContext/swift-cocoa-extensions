import XCTest
@testable import CocoaExtensions

final class CocoaExtensionsTests: XCTestCase {
	func testCustomView() throws {
		// Should compile
		class ImageController: CustomCocoaViewController {
			@CustomView
			var customView: CustomCocoaView!
		}
	}
}
