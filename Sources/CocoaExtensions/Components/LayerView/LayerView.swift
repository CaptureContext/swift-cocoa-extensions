#if os(iOS)
import CocoaAliases

open class LayerView<Layer: CALayer>: CustomCocoaView {
	open override class var layerClass: AnyClass { Layer.self }
	public var actualLayer: Layer! { layer as? Layer }

	public var onLayout: ((Layer) -> Void)?

	open override func layoutSublayers(of layer: CALayer) {
		super.layoutSublayers(of: layer)
		guard actualLayer === layer else { return }
		onLayout?(actualLayer)
	}
}
#endif
