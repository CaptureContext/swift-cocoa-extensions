#if os(iOS)
import CocoaAliases

extension UIEdgeInsets {
	@inlinable
	public static func edges(
		top: CGFloat = 0,
		leading: CGFloat = 0,
		bottom: CGFloat = 0,
		trailing: CGFloat = 0
	) -> Self {
		.init(
			top: top,
			left: leading,
			bottom: bottom,
			right: trailing
		)
	}

	@inlinable
	public static func top(_ inset: CGFloat) -> Self {
		.edges(top: inset)
	}

	@inlinable
	public static func bottom(_ inset: CGFloat) -> Self {
		.edges(bottom: inset)
	}

	@inlinable
	public static func leading(_ inset: CGFloat) -> Self {
		.edges(leading: inset)
	}

	@inlinable
	public static func trailing(_ inset: CGFloat) -> Self {
		.edges(trailing: inset)
	}

	@inlinable
	public static func dimensions(dx: CGFloat = 0, dy: CGFloat = 0) -> Self {
		.edges(
			top: dy,
			leading: dx,
			bottom: dy,
			trailing: dx
		)
	}

	@inlinable
	public static func all(_ inset: CGFloat) -> Self {
		.dimensions(dx: inset, dy: inset)
	}

	@inlinable
	public static func horizontal(_ inset: CGFloat) -> Self {
		.dimensions(dx: inset)
	}

	@inlinable
	public static func vertical(_ inset: CGFloat) -> Self {
		.dimensions(dy: inset)
	}

	@inlinable
	public static func concat(_ insets: [Self]) -> Self {
		return insets.reduce(into: .init()) { buffer, item in
			buffer.top += item.top
			buffer.left += item.left
			buffer.bottom += item.bottom
			buffer.right += item.right
		}
	}
}
#endif
