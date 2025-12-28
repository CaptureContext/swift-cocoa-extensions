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

	public var overrideNavigationController: () -> UINavigationController? = { nil }

	override open var navigationController: UINavigationController? {
		overrideNavigationController() ?? super.navigationController
	}

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onDismiss: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewDidLoad: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewWillAppear: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewDidAppear: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewWillDisappear: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewDidDisappear: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewWillLayout: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewDidLayout: (() -> Void)?

	open override func viewDidLoad() {
		super.viewDidLoad()
		onViewDidLoad?()
	}

	open override func viewWillAppear(_ animated: Bool) {
		super.viewWillAppear(animated)
		onViewWillAppear?()
	}

	open override func viewDidAppear(_ animated: Bool) {
		isVisible = true
		super.viewDidAppear(animated)
		onViewDidAppear?()
	}

	open override func viewWillDisappear(_ animated: Bool) {
		super.viewWillDisappear(animated)
		onViewWillDisappear?()
	}

	open override func viewDidDisappear(_ animated: Bool) {
		super.viewDidDisappear(animated)
		onViewDidDisappear?()
		isVisible = false
	}

	open override func viewWillLayoutSubviews() {
		super.viewWillLayoutSubviews()
		onViewWillLayout?()
	}

	open override func viewDidLayoutSubviews() {
		super.viewDidLayoutSubviews()
		onViewDidLayout?()
	}

	open override func dismiss(animated: Bool, completion: (() -> Void)? = nil) {
		super.dismiss(animated: animated, completion: completion)
		onDismiss?()
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

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onDismiss: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewDidLoad: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewWillAppear: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewDidAppear: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewWillDisappear: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewDidDisappear: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewWillLayout: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onViewDidLayout: (() -> Void)?

	open override func viewDidLoad() {
		super.viewDidLoad()
		onViewDidLoad?()
	}

	open override func viewWillAppear() {
		super.viewWillAppear()
		onViewWillAppear?()
	}

	open override func viewDidAppear() {
		isVisible = true
		super.viewDidAppear()
		onViewDidAppear?()
	}

	open override func viewWillDisappear() {
		super.viewWillDisappear()
		onViewWillDisappear?()
	}

	open override func viewDidDisappear() {
		super.viewDidDisappear()
		onViewDidDisappear?()
		isVisible = false
	}

	open override func viewWillLayout() {
		super.viewWillLayout()
		onViewWillLayout?()
	}

	open override func viewDidLayout() {
		super.viewDidLayout()
		onViewDidLayout?()
	}

	open override func dismiss(_ sender: Any?) {
		super.dismiss(sender)
		self.onDismiss?()
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
