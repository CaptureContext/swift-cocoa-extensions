#if canImport(Darwin)
import Testing
@testable import CocoaExtensionsMacros

#if !os(watchOS)
@MainActor
@Suite
struct CustomViewTests {
	@Test
	func customView() throws {
		class Controller: CustomCocoaViewController {
			@CustomView
			var contentView: CustomCocoaView!
		}

		let controller = Controller()
		#expect(controller.view === controller.contentView)
	}
}
#endif
#endif
