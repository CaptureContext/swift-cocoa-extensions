#if canImport(Darwin)
#if !os(watchOS)
import CocoaAliases

#if os(macOS)
@MainActor
public protocol CustomCocoaWindowProtocol: CustomCocoaObjectProtocol {
	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onClose: (() -> Void)? { get set }
}
#elseif canImport(UIKit)
@MainActor
public protocol CustomCocoaWindowProtocol: CustomCocoaViewProtocol {}
#endif
#endif
#endif
