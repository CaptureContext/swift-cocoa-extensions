#if canImport(UIKit) && !os(watchOS)
import FunctionalClosures

@MainActor
public protocol NavigationControllerDynamicOverridable {
	var overrideNavigationController: () -> UINavigationController? { get set }
}
#endif
