#if canImport(CoreGraphics)
import CoreGraphics

#if canImport(SwiftUI)
import SwiftUI
#endif

extension CGPoint {
	@inlinable
	public init(_ offset: CGSize) {
		self.init(x: offset.width, y: offset.height)
	}

	#if canImport(SwiftUI)
	@inlinable
	public subscript(axis: Axis) -> CGFloat {
		get {
			switch axis {
			case .vertical: return y
			case .horizontal: return x
			}
		}
		set {
			switch axis {
			case .vertical: y = newValue
			case .horizontal: x = newValue
			}
		}
	}
	#endif
}
#endif
