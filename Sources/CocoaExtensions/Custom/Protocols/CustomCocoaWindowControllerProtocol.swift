#if os(macOS)
import CocoaAliases

@MainActor
public protocol CustomCocoaWindowControllerProtocol:
	NSWindowController,
	CustomCocoaObjectProtocol
{
	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onWindowWillLoad: (() -> Void)? { get set }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onWindowDidLoad: (() -> Void)? { get set }
}
#endif
