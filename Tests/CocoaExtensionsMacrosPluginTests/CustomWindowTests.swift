import XCTest
import MacroTesting
import CocoaExtensionsMacrosPlugin

final class CustomWindowTests: XCTestCase {
	override func invokeTest() {
		withMacroTesting(
			isRecording: false,
			macros: [
				"CustomWindow": CustomWindowMacro.self
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
				var managedWindow
			}
			"""
		} diagnostics: {
			"""
			class WindowController: CustomCocoaWindowController {
				@CustomWindow
				var managedWindow
			 ╰─ 🛑 `@CustomWindow` requires explicit type declaration.
			}
			"""
		}
	}

	func testAttachmentToNonOptionalProperty() {
		assertMacro {
			"""
			class WindowController {
				@CustomWindow
				var managedWindow: ContentWindow
			}
			"""
		} diagnostics: {
			"""
			class WindowController {
				@CustomWindow
				var managedWindow: ContentWindow
			                    ╰─ 🛑 `@CustomWindow` requires property to be of Optional type
			                       ✏️ Add exclamation mark
			}
			"""
		}fixes: {
			"""
			class WindowController {
				@CustomWindow
				var managedWindow: ContentWindow!
			}
			"""
		} expansion: {
			"""
			class WindowController {
				var managedWindow: ContentWindow! {
					get {
						self.window as? ContentWindow
					}
					set {
						self.window = newValue
					}
				}

				public override func loadWindow() {
					self.managedWindow = ContentWindow()
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
						self.window as? ContentWindow
					}
					set {
						self.window = newValue
					}
				}

				public override func loadWindow() {
					self.customWindow = ContentWindow()
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
						self.window as? ContentWindow
					}
					set {
						self.window = newValue
					}
				}

				public override func loadWindow() {
					self.customWindow = CustomWindow(fancyInit: true)
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
						self.window as? ContentWindow
					}
					set {
						self.window = newValue
					}
				}

				open override func loadWindow() {
					self.customWindow = ContentWindow()
				}
			}
			"""
		}
	}
}
