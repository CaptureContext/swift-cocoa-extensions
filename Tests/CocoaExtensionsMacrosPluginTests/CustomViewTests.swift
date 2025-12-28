import XCTest
import MacroTesting
import CocoaExtensionsMacrosPlugin

final class CustomViewTests: XCTestCase {
	override func invokeTest() {
		withMacroTesting(
			record: false,
			macros: [
				"CustomView": CustomViewMacro.self
			]
		) {
			super.invokeTest()
		}
	}

	func testAttachmentToNonUntypedProperty() {
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

	func testAttachmentToNonOptionalProperty() {
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

	func testAttachment() {
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

	func testAttachmentWithInitialValue() {
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

	func testAttachmentWithTypedInitialValue() {
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

	func testOpenAttachment() {
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
