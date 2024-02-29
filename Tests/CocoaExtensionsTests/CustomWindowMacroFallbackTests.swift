import XCTest
@testable import CocoaExtensions

#if !os(watchOS)
final class CustomWindowMacroFallbackTests: XCTestCase {
	func testCustomWindow() {
		// Should compile
		class Controller: CustomCocoaWindowController {
			@_CustomWindow
			var managedWindow: CustomCocoaWindow!
		}

		let controller = Controller()
		controller.loadWindow()
		XCTAssertEqual(controller.window, controller.managedWindow)
	}
}
#endif
