#if !os(watchOS) && canImport(Darwin)
import CocoaAliases

open class CustomCollectionReusableView: CocoaCollectionReusableView, CustomCocoaViewProtocol {
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self._init()
	}

	public required init?(coder: NSCoder) {
		super.init(coder: coder)
		self._init()
	}

	/// Only for `override` purposes, do not call directly
	open func _init() {}
}
#endif
