#if !os(watchOS)
import CocoaAliases
import FunctionalClosures

#if os(macOS)
open class CustomCocoaWindow: CocoaWindow, CustomCocoaWindowProtocol {
	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	public var onClose: (() -> Void)?

	public override func close() {
		super.close()
		onClose?()
	}
	
	public override init(
		contentRect: NSRect,
		styleMask style: NSWindow.StyleMask,
		backing backingStoreType: NSWindow.BackingStoreType,
		defer flag: Bool
	) {
		super.init(
			contentRect: contentRect,
			styleMask: style,
			backing: backingStoreType,
			defer: flag
		)
		self._init()
	}
	
	open func _init() {
		_nonisolatedInit()
	}

	open func _nonisolatedInit() {}
}
#elseif canImport(UIKit)
open class CustomCocoaWindow: CocoaWindow, CustomCocoaWindowProtocol {
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self._init()
	}
	
	public override init(windowScene: UIWindowScene) {
		super.init(windowScene: windowScene)
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
