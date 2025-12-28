#if canImport(UIKit) && !os(watchOS)
import CocoaAliases

@available(*, deprecated, message: "Consider copying sources")
public class CollectionReusableView<
	Content: CocoaView
>: CustomCollectionReusableView {
	public let content: Content = .init()
	
	public override func _init() {
		super._init()
		self.addSubview(content)
	}
	
	public override func layoutSubviews() {
		content.frame = bounds
	}
}

#endif
