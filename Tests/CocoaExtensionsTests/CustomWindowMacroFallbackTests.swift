#if canImport(Darwin)
import Testing
@testable import CocoaExtensions

#if !os(watchOS)
@MainActor
@Suite
struct CustomWindowMacroFallbackTests {
	@Test
	func customWindow() {
		// Should compile
		class Controller: CustomCocoaWindowController {
			@_CustomWindow
			var managedWindow: CustomCocoaWindow!
		}

		let controller = Controller()
		controller.loadWindow()
		#expect(controller.window === controller.managedWindow)
	}
}
#endif
#endif
