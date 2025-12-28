#if os(macOS)
import CocoaAliases
import FunctionalClosures

public protocol CustomCocoaWindowControllerProtocol:
	NSWindowController,
	CustomNSObjectProtocol
{
	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onWindowWillLoad: (() -> Void)? { get set }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onWindowDidLoad: (() -> Void)? { get set }
}
#endif
