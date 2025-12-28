#if canImport(UIKit) && !os(watchOS)
import FunctionalClosures

public protocol NavigationControllerDynamicOverridable {
	var overrideNavigationController: () -> UINavigationController? { get set }
}
#endif
