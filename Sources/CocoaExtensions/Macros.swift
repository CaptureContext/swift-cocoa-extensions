// There is a bug in Xcode when the package is imported as a dependency
// https://forums.swift.org/t/xcode-15-beta-no-such-module-error-with-swiftpm-and-macro/65486/3
#if canImport(CocoaExtensionsMacros)
import CocoaExtensionsMacros

#if !os(watchOS)
@attached(accessor)
@attached(peer, names: named(loadView))
public macro CustomView() = #externalMacro(
	module: "CocoaExtensionsMacros",
	type: "CustomViewMacro"
)
#endif

#if os(macOS)
@attached(accessor)
@attached(peer, names: named(loadWindow))
public macro CustomWindow() = #externalMacro(
	module: "CocoaExtensionsMacros",
	type: "CustomWindowMacro"
)
#endif

#else
// Use propertyWrappers to emulate macros
// if CocoaExtensionsMacros is not available

#if !os(watchOS)
import CocoaAliases
import FunctionalClosures
import FoundationExtensions

/// Allows to access typed view of a viewController via corresponding property
///
/// > Will be replaced with macro
///
/// Usage:
/// ```
/// final class ViewController: CustomCocoaViewController {
///   @CustomView
///   var contentView: ContentView
///
///   override func viewDidLoad() {
///     super.viewDidLoad()
///     contentView.label.text = "Hello, World"
///   }
/// }
///
/// extension ViewController {
///   final class ContentView: CustomCocoaView {
///     let label = UILabel { $0
///       .textAlignment(.center)
///     }
///
///     override func _init() {
///       addSubview(label)
///     }
///
///     override func layoutSubviews() {
///       label.frame = bounds
///     }
///   }
/// }
/// ```
///
/// Note, that you should subclass `CustomCocoaViewController` and use `contentView` identifier for the variable
/// to enable implicit loading. Otherwise you should implement loadView method yourself.
/// ```
/// final class ViewController: CocoaViewController {
///   @CustomView
///   var contentView: ContentView
///   override func loadView() {
///     _contentView.load(to: self)
///   }
/// }
/// ```
@propertyWrapper
public struct CustomView<ContentView: CocoaView>: CustomReflectable {
	public static subscript<Controller: CocoaViewController>(
		_enclosingInstance controller: Controller,
		wrapped wrappedKeyPath: ReferenceWritableKeyPath<Controller, ContentView>,
		storage storageKeyPath: ReferenceWritableKeyPath<Controller, Self>
	) -> ContentView {
		get {
			guard let contentView = controller[keyPath: \.view] as? ContentView else {
				assertionFailure("""
				`\(String(reflecting: Controller.self))` should inherit from CustomCocoaViewController \
				to load view using `@CustomView` property wrapper
				""")

				return controller[keyPath: storageKeyPath].load(to: controller)
			}
			return contentView
		}
		set {
			controller[keyPath: storageKeyPath].load(newValue, to: controller)
		}
	}

	public var customMirror: Mirror {
		Mirror(self, children: [("loadView", { load(to: $0) })])
	}

	public init() {
		self.init(wrappedValue: ContentView())
	}

	public init(wrappedValue contentView: ContentView!) {
		self.contentView = { contentView }
	}

	private var contentView: () -> ContentView?

	@available(*, unavailable, message: "@CustomView can only be applied to classes")
	public var wrappedValue: ContentView! {
		get { fatalError() }
		set { fatalError() }
	}

	@discardableResult
	public func load(
		to controller: CocoaViewController
	) -> ContentView {
		return load(contentView()!, to: controller)
	}

	@discardableResult
	public func load(
		_ contentView: ContentView,
		to controller: CocoaViewController
	) -> ContentView {
		controller.view = contentView
		return contentView
	}
}

extension CocoaViewController {
	/// Loads `@CustomView var contentView` to the controller
	/// - Returns: `true` if loading succeed, `false` if failed
	@discardableResult
	func tryLoadCustomContentView() -> Bool {
		let selfMirror = Mirror(reflecting: self)
		guard
			let _contentView = selfMirror.children
				.first(where: { $0.label == "_contentView" })?.value,
			let loadView = Mirror(reflecting: _contentView).children
				.first(where: { $0.label == "loadView" })?.value,
			let loadViewTo = loadView as? ((CocoaViewController) -> Void)
		else { return false }
		loadViewTo(self)
		return true
	}
}
#endif

#if os(macOS)
import CocoaAliases

@propertyWrapper
public struct CustomWindow<Window: CocoaWindow>: CustomReflectable {
	public static subscript<Controller: NSWindowController>(
		_enclosingInstance controller: Controller,
		wrapped wrappedKeyPath: ReferenceWritableKeyPath<Controller, Window>,
		storage storageKeyPath: ReferenceWritableKeyPath<Controller, Self>
	) -> Window {
		get {
			guard let _window = controller[keyPath: \.window] else {
				if !controller.tryLoadCustomWindow() {
					assertionFailure("Could not load custom window")
				}

				let window = Window()
				controller[keyPath: storageKeyPath].load(window, to: controller)
				return window
			}

			guard let window = _window.as(Window.self) else {
				assertionFailure("""
				`\(String(reflecting: Controller.self))` should inherit from CustomCocoaWindowController \
				to load window using `@CustomWindow` property wrapper
				""")

				return controller[keyPath: storageKeyPath].load(to: controller)
			}
			return window
		}
		set {
			controller[keyPath: storageKeyPath].load(newValue, to: controller)
		}
	}

	public var customMirror: Mirror {
		Mirror(self, children: [("loadWindow", { load(to: $0) })])
	}


	public init() {
		self.init(wrappedValue: Window())
	}

	public init(wrappedValue window: Window!) {
		self.managedWindow = { window }
	}

	private var managedWindow: () -> Window?

	@available(*, unavailable, message: "@CustomWindow can only be applied to classes")
	public var wrappedValue: Window! {
		get { fatalError() }
		set { fatalError() }
	}

	@discardableResult
	public func load(
		to controller: NSWindowController
	) -> Window {
		return load(managedWindow()!, to: controller)
	}

	@discardableResult
	public func load(
		_ managedWindow: Window,
		to controller: NSWindowController
	) -> Window {
		controller.window = managedWindow
		return managedWindow
	}
}

extension NSWindowController {
	@discardableResult
	func tryLoadCustomWindow() -> Bool {
		guard
			let _managedWindow = Mirror(reflecting: self).children.first(where: { $0.label == "_managedWindow" })?.value,
			let loadWindow = Mirror(reflecting: _managedWindow).children.first(where: { $0.label == "loadWindow" })?.value,
			let loadWindowTo = loadWindow as? ((NSWindowController) -> Void)
		else { return false }
		loadWindowTo(self)
		return true
	}
}
#endif

#endif
