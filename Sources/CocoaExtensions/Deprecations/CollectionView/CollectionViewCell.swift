#if canImport(UIKit) && !os(watchOS)
import CocoaAliases

@available(*, deprecated, message: "Consider copying sources")
public final class CollectionViewCell<
	Content: CocoaView
>: CustomCollectionViewCell {
	@available(*, deprecated, message: "Use cell.content instead")
	public override var contentView: UIView { super.contentView }

	@Handler1<Content>
	public var onPrepareForReuse

	public var content: Content = .init() {
		didSet {
			if oldValue == content { return }
			oldValue.removeFromSuperview()
			content.removeFromSuperview()
			contentView.addSubview(content)
			setNeedsLayout()
		}
	}

	public override func prepareForReuse() {
		super.prepareForReuse()
		_onPrepareForReuse(content)
	}

	public override func _init() {
		super._init()
		super.contentView.addSubview(content)
	}
	
	public override func layoutSubviews() {
		super.contentView.frame = bounds
		content.frame = bounds
	}
}
#endif
