#if canImport(Darwin) && canImport(CoreGraphics)
import CoreGraphics
import QuartzCore

extension CGAffineTransform {
	public var transform3D: CATransform3D { .affine(self) }
}

extension CATransform3D {
	public static var identity: Self { CATransform3DIdentity }
	
	public static func concat(_ a: CATransform3D, _ b: CATransform3D) -> Self {
		CATransform3DConcat(a, b)
	}
	
	public static func combine(_ transforms: CATransform3D...) -> Self {
		guard var output = transforms.first else { return .identity }
		transforms.dropFirst().forEach { next in
			output = output.combined(with: next)
		}
		return output
	}
	
	public static func translate(x: CGFloat = 0, y: CGFloat = 0, z: CGFloat = 0) -> Self {
		CATransform3DMakeTranslation(x, y, z)
	}
	
	public static func scale(x: CGFloat = 1, y: CGFloat = 1, z: CGFloat = 1) -> Self {
		CATransform3DMakeScale(x, y, z)
	}
	
	public static func affine(_ t: CGAffineTransform) -> Self {
		CATransform3DMakeAffineTransform(t)
	}
	
	@inlinable
	public static func rotate(
		by angle: CGFloat = .pi,
		x: CGFloat = 0,
		y: CGFloat = 0,
		z: CGFloat = 0
	) -> Self
	{
		CATransform3DMakeRotation(angle, x, y, z)
	}
	
	@available(*, deprecated, renamed: "rotate(by:x:y:z:)")
	public static func rotate(
		angle: CGFloat = .pi,
		x: CGFloat = 0,
		y: CGFloat = 0,
		z: CGFloat = 0
	) -> Self {
		CATransform3DMakeRotation(angle, x, y, z)
	}
	
	public func combined(with transform: CATransform3D) -> Self {
		.concat(self, transform)
	}
}
#endif
