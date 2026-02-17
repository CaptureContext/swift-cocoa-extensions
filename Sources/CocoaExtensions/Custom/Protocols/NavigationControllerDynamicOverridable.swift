#if canImport(UIKit) && !os(watchOS)
import UIKit

@available(
	*, deprecated,
	message: """
	This protocol is deprecated and will be removed. \
	It was used for `combine-cocoa-navigation`
	"""
)
@MainActor
public protocol NavigationControllerDynamicOverridable {
	@available(
		*, deprecated,
		message: """
		This protocol is deprecated and will be removed. \
		It was used for `combine-cocoa-navigation`
		"""
	)
	var overrideNavigationController: () -> UINavigationController? { get set }
}
#endif
