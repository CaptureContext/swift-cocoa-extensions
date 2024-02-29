#if !os(watchOS)
import CocoaAliases
import FunctionalClosures

#if os(macOS)
open class CustomCollectionViewCell:
	CocoaCollectionViewCell,
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

	open override func loadView() {
		guard !tryLoadCustomContentView() else { return }
		super.loadView()
	}

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
		isVisible = true
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
	open func _init() {}
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

	open func _init() {}
}
#endif
#endif
