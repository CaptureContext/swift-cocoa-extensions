import XCTest
@testable import CocoaExtensionsMacros

#if !os(watchOS)
final class CustomViewTests: XCTestCase {
	func testCustomView() throws {
		class Controller: CustomCocoaViewController {
			@CustomView
			var contentView: CustomCocoaView!
		}

		let controller = Controller()
		XCTAssertEqual(controller.view, controller.contentView)
	}
}
#endif
