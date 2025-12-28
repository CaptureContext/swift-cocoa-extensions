import CoreGraphics
import SwiftUI

extension CGPoint {
	@inlinable
	public init(_ offset: CGSize) {
		self.init(x: offset.width, y: offset.height)
	}

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
}

