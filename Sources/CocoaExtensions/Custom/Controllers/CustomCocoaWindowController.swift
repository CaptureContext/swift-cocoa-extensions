#if os(macOS)
import CocoaAliases
import FunctionalClosures

open class CustomCocoaWindowController:
	NSWindowController,
	CustomCocoaWindowControllerProtocol
{
	@Handler<Void>
	public var onWindowWillLoad

	@Handler<Void>
	public var onWindowDidLoad

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

	#if !canImport(CocoaExtensionsMacros)
	open override func loadWindow() {
		guard !tryLoadCustomWindow() else { return }
		super.loadWindow()
	}
	#endif

	open func _init() {}

	open override func windowWillLoad() {
		super.windowWillLoad()
		_onWindowWillLoad()
	}

	open override func windowDidLoad() {
		super.windowDidLoad()
		_onWindowDidLoad()
	}
}
#endif
