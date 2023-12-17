#if !os(watchOS)
import CocoaAliases
import FunctionalClosures

#if os(macOS)
open class CustomCollectionViewCell:
	CocoaCollectionViewCell,
	CustomCocoaViewControllerProtocol
{
	@Handler<Void>
	public var onDismiss

	@Handler<Void>
	public var onViewDidLoad

	@Handler<Void>
	public var onViewWillAppear

	@Handler<Void>
	public var onViewDidAppear

	@Handler<Void>
	public var onViewWillDisappear

	@Handler<Void>
	public var onViewDidDisappear

	@Handler<Void>
	public var onViewWillLayout

	@Handler<Void>
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
	}

	open override func viewWillLayout() {
		super.viewWillLayout()
		_onViewWillLayout()
	}

	open override func viewDidLayout() {
		super.viewDidLayout()
		_onViewDidLayout()
	}

	open override func loadView() {
		guard !tryLoadCustomContentView() else { return }
		super.loadView()
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
