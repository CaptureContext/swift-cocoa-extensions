#if os(macOS)
import CocoaAliases
import FunctionalClosures

open class CustomCocoaWindowController:
	NSWindowController,
	CustomCocoaWindowControllerProtocol
{
	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onWindowWillLoad: (() -> Void)?

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onWindowDidLoad: (() -> Void)?

	/// Use `override _init` instead of overriding this initializer
	public override init(window: CocoaWindow?) {
		super.init(window: window)
		self._init()
	}

	/// Use `override _init` instead of overriding this initializer
	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self._init()
	}

	open override func loadWindow() {
		guard !tryLoadCustomWindow() else { return }
		super.loadWindow()
	}

	open func _init() {
		_nonisolatedInit()
	}

	open func _nonisolatedInit() {}

	open override func windowWillLoad() {
		super.windowWillLoad()
		onWindowWillLoad?()
	}

	open override func windowDidLoad() {
		super.windowDidLoad()
		onWindowDidLoad?()
	}
}
#endif
