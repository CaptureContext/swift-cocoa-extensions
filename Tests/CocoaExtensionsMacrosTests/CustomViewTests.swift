import XCTest
import MacroTesting
import CocoaExtensionsMacros

final class CustomViewTests: XCTestCase {
  override func invokeTest() {
    withMacroTesting(
      isRecording: false,
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
				var customView
			}
			"""
		} diagnostics: {
		  """
		  class ViewController: CustomCocoaViewController {
		  	@CustomView
		  	var customView
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
				var customView: ContentView
			}
			"""
		} diagnostics: {
		  """
		  class ViewController: CustomCocoaViewController {
		  	@CustomView
		  	var customView: ContentView
		                   ╰─ 🛑 `@CustomView` requires property to be of Optional type
		                      ✏️ Add exclamation mark
		  }
		  """
		} fixes: {
		  """
		  class ViewController: CustomCocoaViewController {
		  	@CustomView
		  	var customView: ContentView!
		  }
		  """
		}expansion: {
		  """
		  class ViewController: CustomCocoaViewController {
		  	var customView: ContentView! {
		  		get {
		  			self.view as? ContentView
		  		}
		  		set {
		  			self.view = newValue
		  		}
		  	}

		  	public override func loadView() {
		  		self.view = ContentView()
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
				var customView: ContentView!
			}
			"""
		} expansion: {
		  """
		  class ViewController: CustomCocoaViewController {
		  	var customView: ContentView! {
		  		get {
		  			self.view as? ContentView
		  		}
		  		set {
		  			self.view = newValue
		  		}
		  	}

		  	public override func loadView() {
		  		self.view = ContentView()
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
				var customView: ContentView! = CustomView(fancyInit: true)
			}
			"""
		} expansion: {
		  """
		  class ViewController: CustomCocoaViewController {
		  	var customView: ContentView! = CustomView(fancyInit: true) {
		  		get {
		  			self.view as? ContentView
		  		}
		  		set {
		  			self.view = newValue
		  		}
		  	}

		  	public override func loadView() {
		  		self.view = CustomView(fancyInit: true)
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
				open var customView: ContentView!
			}
			"""
		} expansion: {
		  """
		  class ViewController: CustomCocoaViewController {
		  	open var customView: ContentView! {
		  		get {
		  			self.view as? ContentView
		  		}
		  		set {
		  			self.view = newValue
		  		}
		  	}

		  	open override func loadView() {
		  		self.view = ContentView()
		  	}
		  }
		  """
		}
	}
}
