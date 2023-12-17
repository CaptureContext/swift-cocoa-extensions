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

	public override init(window: CocoaWindow?) {
		super.init(window: window)
		self._init()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self._init()
	}

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
