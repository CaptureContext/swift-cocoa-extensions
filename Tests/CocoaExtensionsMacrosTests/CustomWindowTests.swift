import XCTest
@testable import CocoaExtensionsMacros

#if os(macOS)
final class CustomWindowTests: XCTestCase {
	func testCustomWindow() {
		// Should compile
		class Controller: CustomCocoaWindowController {
			@CustomWindow
			var managedWindow: CustomCocoaWindow!
		}

		let controller = Controller()
		controller.loadWindow()
		XCTAssertEqual(controller.window, controller.managedWindow)
	}
}
#endif
