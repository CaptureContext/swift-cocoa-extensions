#if !os(watchOS)
import CocoaAliases

open class CustomCocoaCollectionView: CocoaCollectionView, CustomCocoaViewProtocol {
	#if canImport(UIKit)
	public override init(
		frame: CGRect,
		collectionViewLayout layout: CocoaCollectionViewLayout
	) {
		super.init(frame: frame, collectionViewLayout: layout)
		self._init()
	}
	#else
	public override init(frame: CGRect) {
		super.init(frame: frame)
		self._init()
	}
	#endif

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
