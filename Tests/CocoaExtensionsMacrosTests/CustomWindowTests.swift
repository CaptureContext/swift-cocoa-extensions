import XCTest
import MacroTesting
import CocoaExtensionsMacros

final class CustomWindowTests: XCTestCase {
	override func invokeTest() {
		withMacroTesting(
			isRecording: false,
			macros: [
				"CustomWindow": CustomViewMacro.self
			]
		) {
			super.invokeTest()
		}
	}

	func testAttachmentToNonUntypedProperty() {
		assertMacro {
			"""
			class WindowController: CustomCocoaWindowController {
				@CustomWindow
				var customWindow
			}
			"""
		} diagnostics: {
			"""
			class WindowController: CustomCocoaWindowController {
				@CustomWindow
				var customWindow
			 ╰─ 🛑 `@CustomView` requires explicit type declaration.
			}
			"""
		}
	}

	func testAttachmentToNonOptionalProperty() {
		assertMacro {
			"""
			class WindowController {
				@CustomWindow
				var customWindow: ContentWindow
			}
			"""
		} diagnostics: {
			"""
			class WindowController {
				@CustomWindow
				var customWindow: ContentWindow
			                   ╰─ 🛑 `@CustomView` requires property to be of Optional type
			                      ✏️ Add exclamation mark
			}
			"""
		} fixes: {
			"""
			class WindowController {
				@CustomWindow
				var customWindow: ContentWindow!
			}
			"""
		} expansion: {
			"""
			class WindowController {
				var customWindow: ContentWindow! {
					get {
						self.view as? ContentWindow
					}
					set {
						self.view = newValue
					}
				}

				public override func loadView() {
					self.view = ContentWindow()
				}
			}
			"""
		}
	}

	func testAttachment() {
		assertMacro {
			"""
			class WindowController {
				@CustomWindow
				var customWindow: ContentWindow!
			}
			"""
		} expansion: {
			"""
			class WindowController {
				var customWindow: ContentWindow! {
					get {
						self.view as? ContentWindow
					}
					set {
						self.view = newValue
					}
				}

				public override func loadView() {
					self.view = ContentWindow()
				}
			}
			"""
		}
	}

	func testAttachmentWithInitialValue() {
		assertMacro {
			"""
			class WindowController {
				@CustomWindow
				var customWindow: ContentWindow! = CustomWindow(fancyInit: true)
			}
			"""
		} expansion: {
			"""
			class WindowController {
				var customWindow: ContentWindow! = CustomWindow(fancyInit: true) {
					get {
						self.view as? ContentWindow
					}
					set {
						self.view = newValue
					}
				}

				public override func loadView() {
					self.view = CustomWindow(fancyInit: true)
				}
			}
			"""
		}
	}

	func testOpenAttachment() {
		assertMacro {
			"""
			class WindowController {
				@CustomWindow
				open var customWindow: ContentWindow!
			}
			"""
		} expansion: {
			"""
			class WindowController {
				open var customWindow: ContentWindow! {
					get {
						self.view as? ContentWindow
					}
					set {
						self.view = newValue
					}
				}

				open override func loadView() {
					self.view = ContentWindow()
				}
			}
			"""
		}
	}
}
