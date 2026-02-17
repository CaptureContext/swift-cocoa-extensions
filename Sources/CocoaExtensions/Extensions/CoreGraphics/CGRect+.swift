#if canImport(CoreGraphics)
import CoreGraphics

#if canImport(SwiftUI)
import SwiftUI
#endif

extension CGRect {
	@inlinable
	public init(
		minX: CGFloat,
		minY: CGFloat,
		maxX: CGFloat,
		maxY: CGFloat
	) {
		self.init(
			x: minX,
			y: minY,
			width: maxX - minX,
			height: maxY - minY
		)
	}

	#if canImport(SwiftUI)
	@inlinable
	public subscript(max axis: Axis) -> CGFloat {
		switch axis {
		case .vertical: return maxY
		case .horizontal: return maxX
		}
	}

	@inlinable
	public subscript(min axis: Axis) -> CGFloat {
		switch axis {
		case .vertical: return minY
		case .horizontal: return minX
		}
	}

	@inlinable
	public subscript(mid axis: Axis) -> CGFloat {
		switch axis {
		case .vertical: return midY
		case .horizontal: return midX
		}
	}
	#endif
}
#endif
