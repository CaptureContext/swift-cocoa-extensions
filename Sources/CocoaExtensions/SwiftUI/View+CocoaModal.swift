import SwiftUI
import AssociatedObjects
import DeclarativeConfiguration
import CocoaAliases
import FoundationExtensions

#if os(iOS) || targetEnvironment(macCatalyst)
@available(iOS 14.0, *)
extension View {
	/// Presents transparent UIHostingController with provided content on the topmost viewController on the current key window
	///
	/// - Parameters:
	///   - item: Presented item
	///   - presentationStyle: Presentation style override
	///   - transitionStyle: Transition style override
	///   - transitioningDelegate: Transitioning delegate  override
	///   - content: Content to present
	public func cocoaModal<Item, Content: View>(
		item: Binding<Item?>,
		presentationStyle: UIModalPresentationStyle? = nil,
		transitionStyle: UIModalTransitionStyle? = nil,
		transitioningDelegate: UIViewControllerTransitioningDelegate? = nil,
		@ViewBuilder content: @escaping (Item) -> Content,
	) -> some View {
		cocoaModal(
			isPresented: item._isCocoaModalPresented,
			presentationStyle: presentationStyle,
			transitionStyle: transitionStyle,
			transitioningDelegate: transitioningDelegate,
			onPresented: nil,
			content: {
				_OptionalContentView(
					item: item,
					content: content
				)
			}
		)
	}

	/// Presents transparent UIHostingController with provided content on the topmost viewController on the current key window
	///
	/// - Parameters:
	///   - isPresented: Presentation state binding
	///   - presentationStyle: Presentation style override
	///   - transitionStyle: Transition style override
	///   - transitioningDelegate: Transitioning delegate  override
	///   - content: Content to present
	public func cocoaModal<Content: View>(
		isPresented: Binding<Bool>,
		presentationStyle: UIModalPresentationStyle? = nil,
		transitionStyle: UIModalTransitionStyle? = nil,
		transitioningDelegate: UIViewControllerTransitioningDelegate? = nil,
		@ViewBuilder content: @escaping () -> Content
	) -> some View {
		EnvironmentReader { env in
			cocoaModal(
				isPresented: isPresented,
				presentationStyle: presentationStyle,
				transitionStyle: transitionStyle,
				transitioningDelegate: transitioningDelegate,
				onPresented: nil,
				content: {
					content()
						.transformEnvironment(\.self) { $0 = env }
				}
			)
		}
	}

	/// Presents transparent UIHostingController with provided content on the topmost viewController on the current key window
	///
	/// - Parameters:
	///   - isPresented: Presentation state binding
	///   - presentationStyle: Presentation style override
	///   - transitionStyle: Transition style override
	///   - transitioningDelegate: Transitioning delegate  override
	///   - content: Content to present
	///
	/// - Warning: This component observes dismiss using custom presentationController's delegate, if you override
	/// it in `onPresented` hook, you need to manually set `isPresented` to `false` on dismiss
	@_spi(Internals)
	public func cocoaModal<Content: View>(
		isPresented: Binding<Bool>,
		presentationStyle: UIModalPresentationStyle?,
		transitionStyle: UIModalTransitionStyle?,
		transitioningDelegate: UIViewControllerTransitioningDelegate?,
		onPresented: ((CocoaViewController) -> Void)?,
		@ViewBuilder content: () -> Content
	) -> some View {
		cocoaModal(
			isPresented: isPresented,
			onPresented: nil,
			controller: {
				let controller = UIHostingController(rootView: content())
				controller.view.backgroundColor = .clear

				if let presentationStyle {
					controller.modalPresentationStyle = presentationStyle
				}

				if let transitionStyle {
					controller.modalTransitionStyle = transitionStyle
				}

				if let transitioningDelegate {
					controller.transitioningDelegate = transitioningDelegate
				}

				return controller
			}()
		)
	}

	/// Presents cocoa view controller on the topmost viewController on the current key window
	///
	/// - Parameters:
	///   - isPresented: Presentation state binding
	///   - controller: Managed controller, modify presentation style using Cocoa APIs
	public func cocoaModal(
		isPresented: Binding<Bool>,
		controller: CocoaViewController,
	) -> some View {
		cocoaModal(
			isPresented: isPresented,
			onPresented: nil,
			controller: controller
		)
	}

	/// Presents cocoa view controller on the topmost viewController on the current key window
	///
	/// - Parameters:
	///   - isPresented: Presentation state binding
	///   - controller: Managed controller, modify presentation style using Cocoa APIs
	///   - onPresented: Hook for presentation completion, useful for overriding presentationController's delegate
	///
	/// - Warning: This component observes dismiss using custom presentationController's delegate, if you override
	/// it in `onPresented` hook, you need to manually set `isPresented` to `false` on dismiss
	@_spi(Internals)
	public func cocoaModal(
		isPresented: Binding<Bool>,
		onPresented: ((CocoaViewController) -> Void)?,
		controller: CocoaViewController
	) -> some View {
		modifier(CocoaPresentationManager(
			isPresented: isPresented,
			controller: controller,
			onPresented: onPresented
		))
	}
}

@available(iOS 14.0, *)
private struct CocoaPresentationManager: ViewModifier {
	@Binding
	private var isPresented: Bool
	private let controller: CocoaViewController
	private let onPresented: ((CocoaViewController) -> Void)?

	init(
		isPresented: Binding<Bool>,
		controller: UIViewController,
		onPresented: ((CocoaViewController) -> Void)?
	) {
		self._isPresented = isPresented
		self.controller = controller
		self.onPresented = onPresented
	}

	func body(content: Content) -> some View {
		if #available(iOS 17, *) {
			content
				.onChange(of: isPresented, initial: true) { updatePresentation(for: $1) }
		} else {
			content
				.onChange(of: isPresented) { updatePresentation(for: $0) }
		}
	}

	func updatePresentation(for isPresented: Bool) {
		if isPresented, controller.presentingViewController == nil {
			resolveTopmostController()?.present(
				controller,
				animated: true,
				completion: {
					let dismissDelegate = controller.dismissDelegate
					dismissDelegate.didDismiss = { self.isPresented = false }
					controller.presentationController?.delegate = dismissDelegate
					onPresented?(controller)
				}
			)
		} else {
			controller.presentingViewController?.dismiss(animated: true)
		}
	}

	func resolveTopmostController() -> UIViewController? {
		func topmostController(from root: UIViewController) -> UIViewController {
			if let presented = root.presentedViewController {
				return topmostController(from: presented)
			}
			if let nav = root as? UINavigationController, let visible = nav.visibleViewController {
				return topmostController(from: visible)
			}
			if let tab = root as? UITabBarController, let selected = tab.selectedViewController {
				return topmostController(from: selected)
			}
			return root
		}

		let scenes = UIApplication.shared.connectedScenes
			.compactMap { $0 as? UIWindowScene }
			.filter { $0.activationState == .foregroundActive }

		// Prefer the key window on the active scene, fall back to any visible window
		let window = scenes
			.flatMap { $0.windows }
			.first { $0.isKeyWindow } ?? scenes.flatMap { $0.windows }.first { !$0.isHidden && $0.alpha > 0 }

		guard let root = window?.rootViewController else { return nil }
		return topmostController(from: root)
	}
}

extension UIViewController {
	fileprivate var dismissDelegate: DismissDelegate {
		get {
			getAssociatedObject(of: DismissDelegate.self, forKey: #function) ?? {
				let delegate = DismissDelegate()
				self.dismissDelegate = delegate
				return delegate
			}()
		}
		set {
			setAssociatedObject(newValue, forKey: #function, policy: .retain(.nonatomic))
		}
	}
}

private class DismissDelegate: NSObject, UIAdaptivePresentationControllerDelegate {
	var didDismiss: () -> Void

	init(
		didDismiss: @escaping () -> Void = {}
	) {
		self.didDismiss = didDismiss
	}

	func presentationControllerDidDismiss(_ presentationController: UIPresentationController) {
		didDismiss()
	}
}

private extension Optional {
	var _isCocoaModalPresented: Bool {
		get { isNotNil }
		set { if !newValue { self = nil } }
	}
}

private struct _OptionalContentView<Item, Content: View>: View {
	@Binding
	private var item: Item?
	private var content: (Item) -> Content

	init(
		item: Binding<Item?>,
		content: @escaping (Item) -> Content
	) {
		self._item = item
		self.content = content
	}

	var body: some View {
		item.map(content)
	}
}

@_spi(Internals)
public struct EnvironmentReader<Content: View>: View {
	@Environment(\.self)
	private var environmentValues

	private let content: (EnvironmentValues) -> Content

	public init(content: @escaping (EnvironmentValues) -> Content) {
		self.content = content
	}

	public var body: some View {
		content(environmentValues)
	}
}

#endif
