#if canImport(Darwin) && canImport(CoreGraphics)
import CoreGraphics

extension CGPath {
	@inlinable
	public static func create(_ build: (CGMutablePath) -> Void) -> CGMutablePath {
		let path = CGMutablePath()
		build(path)
		return path
	}

	@inlinable
	public static func line(from start: CGPoint, to end: CGPoint) -> CGPath {
		.create { $0.addLine(from: start, to: end) }
	}

	@inlinable
	public static func combine(_ paths: [CGPath]) -> CGPath {
		return .create { path in
			for p in paths {
				path.addPath(p)
			}
		}
	}
}

extension CGMutablePath {
	@inlinable
	public func addLine(from start: CGPoint, to end: CGPoint) {
		move(to: start)
		addLine(to: end)
	}
}
#endif
