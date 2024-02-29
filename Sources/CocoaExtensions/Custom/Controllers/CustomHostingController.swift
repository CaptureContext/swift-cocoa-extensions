#if canImport(SwiftUI) && !os(watchOS)
import DeclarativeConfiguration
import CocoaAliases
import SwiftUI

extension CocoaHostingController where Content: ExpressibleByNilLiteral {
	public convenience init() {
		self.init(rootView: nil)
	}
}

#if canImport(UIKit)

extension CustomHostingController: NavigationControllerDynamicOverridable {}

open class CustomHostingController<Content: View>:
	CocoaHostingController<Content>,
	CustomCocoaViewControllerProtocol
{
	private(set) open var isVisible = false

	@OptionalDataSource<Void, UINavigationController?>
	public var overrideNavigationController

	override open var navigationController: UINavigationController? {
		_overrideNavigationController() ?? super.navigationController
	}

	@Handler1<Void>
	public var onDismiss

	@Handler1<Void>
	public var onViewDidLoad

	@Handler1<Void>
	public var onViewWillAppear

	@Handler1<Void>
	public var onViewDidAppear

	@Handler1<Void>
	public var onViewWillDisappear

	@Handler1<Void>
	public var onViewDidDisappear

	@Handler1<Void>
	public var onViewWillLayout

	@Handler1<Void>
	public var onViewDidLayout

	open override func viewDidLoad() {
		super.viewDidLoad()
		_onViewDidLoad()
	}

	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		_onViewWillAppear()
	}

	open override func viewDidAppear(_ animated: Bool) {
		isVisible = true
		super.viewDidAppear(animated)
		_onViewDidAppear()
	}

	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		_onViewWillDisappear()
	}

	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		_onViewDidDisappear()
		isVisible = false
	}

	open override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		_onViewWillLayout()
	}

	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		_onViewDidLayout()
	}

	open override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
		super.dismiss(animated: animated, completion: completion)
		_onDismiss()
	}

	/// Use `override _init` instead of overriding this initializer
	public override init(rootView: Content) {
		super.init(rootView: rootView)
		self._init()
	}

	/// Use `override _init` instead of overriding this initializer
	public override init?(coder: NSCoder, rootView: Content) {
		super.init(coder: coder, rootView: rootView)
		self._init()
	}

	/// Use `override _init` instead of overriding this initializer
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self._init()
	}

	/// Only for `override` purposes, do not call directly
	open func _init() {}
}

#elseif canImport(AppKit)
import DeclarativeConfiguration
import CocoaAliases
import SwiftUI

open class CustomHostingController<Content: View>:
	CocoaHostingController<Content>,
	CustomCocoaViewControllerProtocol
{
	private(set) open var isVisible = false

	@Handler1<Void>
	public var onDismiss

	@Handler1<Void>
	public var onViewDidLoad

	@Handler1<Void>
	public var onViewWillAppear

	@Handler1<Void>
	public var onViewDidAppear

	@Handler1<Void>
	public var onViewWillDisappear

	@Handler1<Void>
	public var onViewDidDisappear

	@Handler1<Void>
	public var onViewWillLayout

	@Handler1<Void>
	public var onViewDidLayout

	open override func viewDidLoad() {
		super.viewDidLoad()
		_onViewDidLoad()
	}

	open override func viewWillAppear() {
		super.viewWillAppear()
		_onViewWillAppear()
	}

	open override func viewDidAppear() {
		isVisible = true
		super.viewDidAppear()
		_onViewDidAppear()
	}

	open override func viewWillDisappear() {
		super.viewWillDisappear()
		_onViewWillDisappear()
	}

	open override func viewDidDisappear() {
		super.viewDidDisappear()
		_onViewDidDisappear()
		isVisible = false
	}

	open override func viewWillLayout() {
		super.viewWillLayout()
		_onViewWillLayout()
	}

	open override func viewDidLayout() {
		super.viewDidLayout()
		_onViewDidLayout()
	}

	open override func dismiss(_ sender: Any?) {
		super.dismiss(sender)
		self._onDismiss()
	}

	/// Use `override _init` instead of overriding this initializer
	public override init(rootView: Content) {
		super.init(rootView: rootView)
		self._init()
	}

	/// Use `override _init` instead of overriding this initializer
	public override init?(coder: NSCoder, rootView: Content) {
		super.init(coder: coder, rootView: rootView)
		self._init()
	}

	/// Use `override _init` instead of overriding this initializer
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self._init()
	}

	/// Only for `override` purposes, do not call directly
	open func _init() {}
}
#endif
#endif
