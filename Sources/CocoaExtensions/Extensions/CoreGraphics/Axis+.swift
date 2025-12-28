import SwiftUI

extension Axis.Set {
	@inlinable
	public init(_ axes: Axis...) {
		self = []

		if axes.contains(.vertical) {
			insert(.vertical)
		}

		if axes.contains(.horizontal) {
			insert(.horizontal)
		}
	}
}

extension Axis {
	@inlinable
	public var orthoganal: Axis {
		switch self {
		case .horizontal: .vertical
		case .vertical: .horizontal
		}
	}
}
