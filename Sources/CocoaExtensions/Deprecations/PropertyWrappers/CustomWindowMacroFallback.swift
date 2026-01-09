#if os(macOS)
import CocoaAliases
import FunctionalClosures
import FoundationExtensions
import CocoaAliases

protocol _CustomWindowLoaderProtocol {
	func _load(to controller: NSWindowController)
}

@available(*, deprecated, renamed: "CustomWindow")
@propertyWrapper
public final class _CustomWindow<Window: CocoaWindow>: _CustomWindowLoaderProtocol {
	@MainActor
	public static subscript<Controller: NSWindowController>(
		_enclosingInstance controller: Controller,
		wrapped wrappedKeyPath: ReferenceWritableKeyPath<Controller, Window>,
		storage storageKeyPath: ReferenceWritableKeyPath<Controller, _CustomWindow>
	) -> Window! {
		get {
			let _window = controller[keyPath: \.window] ?? {
				if !controller.tryLoadCustomWindow() {
					assertionFailure("Could not load custom window")
				}

				let window = Window()
				controller[keyPath: storageKeyPath].load(window, to: controller)
				return window
			}()

			let window = _window.as(Window.self) ?? {
				assertionFailure("""
				`\(String(reflecting: Controller.self))` should inherit from CustomCocoaWindowController \
				to load window using `@CustomWindow` property wrapper
				""")

				return controller[keyPath: storageKeyPath].load(to: controller)
			}()

			return window
		}
		set {
			controller[keyPath: storageKeyPath].load(newValue, to: controller)
		}
	}

	public convenience init() {
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

	func _load(to controller: NSWindowController) {
		self.load(to: controller)
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
	@_spi(Internals)
	@discardableResult
	public func tryLoadCustomWindow() -> Bool {
		guard
			let _managedWindow = Mirror(reflecting: self)
				.children.reduce(_CustomWindowLoaderProtocol?.none, { loader, candidate in
					guard loader == nil else { return nil }
					return candidate.value as? _CustomWindowLoaderProtocol
				})
		else { return false }
		_managedWindow._load(to: self)
		return true
	}
}
#endif
