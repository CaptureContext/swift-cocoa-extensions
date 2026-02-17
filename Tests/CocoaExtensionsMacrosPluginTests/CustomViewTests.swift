import Testing
import MacroTesting
import CocoaExtensionsMacrosPlugin

@Suite(
	.macros(
		["CustomView": CustomViewMacro.self],
		record: false
	)
)
struct CustomViewTests {
	@Test
	func attachmentToNonUntypedProperty() {
		assertMacro {
			"""
			class ViewController: CustomCocoaViewController {
				@CustomView
				var contentView
			}
			"""
		} diagnostics: {
			"""
			class ViewController: CustomCocoaViewController {
				@CustomView
				var contentView
			 ╰─ 🛑 `@CustomView` requires explicit type declaration.
			}
			"""
		}
	}
	@Test
	func attachmentToNonOptionalProperty() {
		assertMacro {
			"""
			class ViewController: CustomCocoaViewController {
				@CustomView
				var contentView: ContentView
			}
			"""
		} diagnostics: {
			"""
			class ViewController: CustomCocoaViewController {
				@CustomView
				var contentView: ContentView
			                  ╰─ 🛑 `@CustomView` requires property to be of Optional type
			                     ✏️ Add exclamation mark
			}
			"""
		} fixes: {
			"""
			class ViewController: CustomCocoaViewController {
				@CustomView
				var contentView: ContentView!
			}
			"""
		} expansion: {
			"""
			class ViewController: CustomCocoaViewController {
				var contentView: ContentView! {
					get {
						self.view as? ContentView
					}
					set {
						self.view = newValue
					}
				}

				public override func loadView() {
					self.contentView = ContentView()
				}
			}
			"""
		}
	}

	@Test
	func attachment() {
		assertMacro {
			"""
			class ViewController: CustomCocoaViewController {
				@CustomView
				var contentView: ContentView!
			}
			"""
		} expansion: {
			"""
			class ViewController: CustomCocoaViewController {
				var contentView: ContentView! {
					get {
						self.view as? ContentView
					}
					set {
						self.view = newValue
					}
				}

				public override func loadView() {
					self.contentView = ContentView()
				}
			}
			"""
		}
	}

	@Test
	func attachmentWithInitialValue() {
		assertMacro {
			"""
			class ViewController: CustomCocoaViewController {
				@CustomView
				var contentView: ContentView! = .init(fancyInit: true)
			}
			"""
		} expansion: {
			"""
			class ViewController: CustomCocoaViewController {
				var contentView: ContentView! {
					get {
						self.view as? ContentView
					}
					set {
						self.view = newValue
					}
				}

				public override func loadView() {
					self.contentView = .init(fancyInit: true)
				}
			}
			"""
		}
	}

	@Test
	func attachmentWithTypedInitialValue() {
		assertMacro {
			"""
			class ViewController: CustomCocoaViewController {
				@CustomView
				var contentView: ContentView! = ContentView(fancyInit: true)
			}
			"""
		} expansion: {
			"""
			class ViewController: CustomCocoaViewController {
				var contentView: ContentView! {
					get {
						self.view as? ContentView
					}
					set {
						self.view = newValue
					}
				}

				public override func loadView() {
					self.contentView = ContentView(fancyInit: true)
				}
			}
			"""
		}
	}

	@Test
	func openAttachment() {
		assertMacro {
			"""
			class ViewController: CustomCocoaViewController {
				@CustomView
				open var contentView: ContentView!
			}
			"""
		} expansion: {
			"""
			class ViewController: CustomCocoaViewController {
				open var contentView: ContentView! {
					get {
						self.view as? ContentView
					}
					set {
						self.view = newValue
					}
				}

				open override func loadView() {
					self.contentView = ContentView()
				}
			}
			"""
		}
	}
}
