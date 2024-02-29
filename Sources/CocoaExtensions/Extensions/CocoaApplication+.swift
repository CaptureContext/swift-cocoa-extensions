import CocoaAliases
import FoundationExtensions

#if os(macOS)
extension CocoaApplication {
	public var firstKeyWindow: CocoaWindow? {
		windows.first(where: { $0.isKeyWindow })
	}
}
#elseif !os(watchOS)
extension UIApplication {
	var keyWindow: UIWindow? {
		return connectedScenes
			.filter { $0.activationState == .foregroundActive }
			.first { $0 is UIWindowScene }
			.flatMap { $0 as? UIWindowScene }
			.map(\.windows)
			.flatMap { $0.first(where: \.isKeyWindow) }
			.or(windows.first(where: \.isKeyWindow))
	}
}
#endif
