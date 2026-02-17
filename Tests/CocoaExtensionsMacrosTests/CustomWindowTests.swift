#if canImport(Darwin)
import Testing
@testable import CocoaExtensionsMacros

#if os(macOS)
@MainActor
@Suite
struct CustomWindowTests {
	@Test
	func customWindow() {
		// Should compile
		class Controller: CustomCocoaWindowController {
			@CustomWindow
			var managedWindow: CustomCocoaWindow!
		}

		let controller = Controller()
		controller.loadWindow()
		#expect(controller.window === controller.managedWindow)
	}
}
#endif
#endif
