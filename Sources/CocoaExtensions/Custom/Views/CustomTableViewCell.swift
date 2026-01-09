#if !os(watchOS)
import CocoaAliases

open class CustomTableViewCell: CocoaTableViewCell, CustomCocoaViewProtocol {
	#if canImport(UIKit)
	public override init(
		style: UITableViewCell.CellStyle,
		reuseIdentifier reuseID: String?
	) {
		super.init(style: style, reuseIdentifier: reuseID)
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
