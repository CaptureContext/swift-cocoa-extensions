import XCTest
@testable import CocoaExtensions

#if !os(watchOS)
final class CustomViewMacroFallbackTests: XCTestCase {
	func testCustomView() throws {
		class Controller: CustomCocoaViewController {
			@_CustomView
			var contentView: CustomCocoaView!
		}

		let controller = Controller()
		XCTAssertEqual(controller.view, controller.contentView)
	}
}
#endif
