import Testing
import MacroTesting
import CocoaExtensionsMacrosPlugin

@Suite(
	.macros(
		["CustomWindow": CustomWindowMacro.self],
		record: false
	)
)
struct CustomWindowTests {
	@Test
	func attachmentToNonUntypedProperty() {
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

	@Test
	func attachmentToNonOptionalProperty() {
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

	@Test
	func attachment() {
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

	@Test
	func attachmentWithInitialValue() {
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
				var customWindow: ContentWindow! {
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

	@Test
	func openAttachment() {
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
