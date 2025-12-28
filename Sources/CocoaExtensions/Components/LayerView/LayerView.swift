#if os(iOS)
import CocoaAliases

open class LayerView<Layer: CALayer>: CustomCocoaView {
	open override class var layerClass: AnyClass { Layer.self }
	public var actualLayer: Layer! { layer as? Layer }
}
#endif
