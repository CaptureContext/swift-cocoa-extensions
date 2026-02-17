#if canImport(Darwin)
import Testing
@testable import CocoaExtensions

#if !os(watchOS)
@MainActor
@Suite
struct CustomViewMacroFallbackTests {
	@Test
	func customView() throws {
		class Controller: CustomCocoaViewController {
			@_CustomView
			var contentView: CustomCocoaView!
		}

		let controller = Controller()
		#expect(controller.view === controller.contentView)
	}
}
#endif
#endif
