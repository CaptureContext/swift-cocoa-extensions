import CoreGraphics
import SwiftUI

extension CGSize {
	@inlinable
	public init(_ point: CGPoint) {
		self.init(width: point.x, height: point.y)
	}

	@inlinable
	public static func square(_ length: CGFloat) -> CGSize {
		self.init(width: length, height: length)
	}

	@inlinable
	public var center: CGPoint {
		CGPoint(x: width / 2, y: height / 2)
	}

	@inlinable
	public subscript(axis: Axis) -> CGFloat {
		get {
			switch axis {
			case .vertical: return height
			case .horizontal: return width
			}
		}
		set {
			switch axis {
			case .vertical: height = newValue
			case .horizontal: width = newValue
			}
		}
	}
}
