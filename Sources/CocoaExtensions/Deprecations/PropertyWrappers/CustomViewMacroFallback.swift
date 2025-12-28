#if !os(watchOS)
import CocoaAliases
import FunctionalClosures
import FoundationExtensions

protocol _CustomViewLoaderProtocol {
	func _load(to controller: CocoaViewController)
}

/// Allows to access typed view of a viewController via corresponding property
///
/// > Will be replaced with macro
///
/// Usage:
/// ```
/// final class ViewController: CustomCocoaViewController {
///   @_CustomView
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
///   @_CustomView
///   var contentView: ContentView
///   override func loadView() {
///     _contentView.load(to: self)
///   }
/// }
/// ```
@available(*, deprecated, renamed: "CustomView")
@propertyWrapper
public final class _CustomView<ContentView: CocoaView>: _CustomViewLoaderProtocol {
	public static subscript<Controller: CocoaViewController>(
		_enclosingInstance controller: Controller,
		wrapped wrappedKeyPath: ReferenceWritableKeyPath<Controller, ContentView>,
		storage storageKeyPath: ReferenceWritableKeyPath<Controller, _CustomView>
	) -> ContentView! {
		get {
			return controller[keyPath: \.view].as(ContentView.self) ?? {
				assertionFailure("""
				`\(String(reflecting: Controller.self))` should inherit from CustomCocoaViewController \
				to load view using `@_CustomView` property wrapper
				""")

				return controller[keyPath: storageKeyPath].load(to: controller)
			}()
		}
		set {
			controller[keyPath: storageKeyPath].load(newValue, to: controller)
		}
	}

	public convenience init() {
		self.init(wrappedValue: ContentView())
	}

	public init(wrappedValue contentView: ContentView!) {
		self.contentView = { contentView }
	}

	private var contentView: () -> ContentView?

	@available(*, unavailable, message: "@_CustomView propery wrapper can only be applied to classes")
	public var wrappedValue: ContentView! {
		get { fatalError() }
		set { fatalError() }
	}

	func _load(to controller: CocoaViewController) {
		self.load(to: controller)
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
	@_spi(Internals)
	@discardableResult
	public func tryLoadCustomContentView() -> Bool {
		guard
			let _contentView = Mirror(reflecting: self)
				.children.reduce(_CustomViewLoaderProtocol?.none, { loader, candidate in
					guard loader == nil else { return nil }
					return candidate.value as? _CustomViewLoaderProtocol
				})
		else { return false }
		_contentView._load(to: self)
		return true
	}
}
#endif
