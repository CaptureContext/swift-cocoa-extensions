#if !os(watchOS) && canImport(Darwin)
import CocoaAliases

open class CustomCocoaCollectionViewFlowLayout: CocoaCollectionViewFlowLayout {
	public override init() {
		super.init()
		self._init()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self._init()
	}

	open func _init() {}
}
#endif
