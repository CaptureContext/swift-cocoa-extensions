#if !os(watchOS)
import CocoaAliases
import FunctionalClosures

#if os(macOS)
public protocol CustomCocoaWindowProtocol: CustomNSObjectProtocol {
	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onClose: (() -> Void)? { get set }
}
#elseif canImport(UIKit)
public protocol CustomCocoaWindowProtocol: CustomCocoaViewProtocol {}
#endif
#endif
