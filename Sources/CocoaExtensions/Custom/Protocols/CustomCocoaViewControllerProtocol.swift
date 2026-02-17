#if canImport(Darwin)
#if !os(watchOS)
import CocoaAliases

@MainActor
public protocol CustomCocoaViewControllerProtocol:
	CocoaViewController,
	CustomCocoaObjectProtocol
{
	var isVisible: Bool { get }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onDismiss: (() -> Void)? { get set }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onViewDidLoad: (() -> Void)? { get set }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onViewWillAppear: (() -> Void)? { get set }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onViewDidAppear: (() -> Void)? { get set }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onViewWillDisappear: (() -> Void)? { get set }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onViewDidDisappear: (() -> Void)? { get set }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onViewWillLayout: (() -> Void)? { get set }

	@available(*, deprecated, message: "Consider using publisher-based interception instead")
	var onViewDidLayout: (() -> Void)? { get set }
}
#endif
#endif
