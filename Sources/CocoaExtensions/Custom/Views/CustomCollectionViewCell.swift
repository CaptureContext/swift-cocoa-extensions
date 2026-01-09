#if !os(watchOS)
import CocoaAliases
import FunctionalClosures

#if os(macOS)
open class CustomCollectionViewCell:
	CocoaCollectionViewCell,
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

	open override func loadView() {
		guard !tryLoadCustomContentView() else { return }
		super.loadView()
	}

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
		isVisible = true
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
	public override init(nibName nibNameOrNil: String?, bundle nibBundleOrNil: Bundle?) {
		super.init(nibName: nibNameOrNil, bundle: nibBundleOrNil)
		self._init()
	}

	/// Use `override _init` instead of overriding this initializer
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self._init()
	}
	/// Only for `override` purposes, do not call directly
	open func _init() {
		_nonisolatedInit()
	}

	open func _nonisolatedInit() {}
}
#else
open class CustomCollectionViewCell:
	CocoaCollectionViewCell,
	CustomCocoaViewProtocol
{
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self._init()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self._init()
	}

	open func _init() {
		_nonisolatedInit()
	}

	open func _nonisolatedInit() {}
}
#endif
#endif
