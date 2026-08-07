#if canImport(SwiftUI) && !os(watchOS)
import SwiftUI
import CocoaAliases
import PerceptionCore

public struct CocoaComponent<Representable: View>: View {
	@_spi(Internals)
	public let content: Representable

	@_spi(Internals)
	public init(content: () -> Representable) {
		self.content = content()
	}

	public var body: some View { content }
}

public struct _CocoaViewRepresentable<Content: CocoaView, Coordinator>: CocoaViewRepresentable {
	@_spi(Internals)
	public let content: (Context) -> Content

	@_spi(Internals)
	public let update: (Content, Context) -> Void

	@_spi(Internals)
	public let sizeThatFits: (_ProposedViewSizeDTO, Content, Context) -> CGSize?

	@_spi(Internals)
	public let coordinator: () -> Coordinator


	@_spi(Internals)
	public init(
		content: @escaping (Context) -> Content,
		update: @escaping (Content, Context) -> Void,
		sizeThatFits: @escaping (_ProposedViewSizeDTO, Content, Context) -> CGSize? = { _, _, _ in nil },
		coordinator: @escaping () -> Coordinator
	) {
		self.content = content
		self.sizeThatFits = sizeThatFits
		self.update = update
		self.coordinator = coordinator
	}

	public func makeCocoaView(context: Context) -> Content {
		_PerceptionLocals.$skipPerceptionChecking.withValue(true) {
			content(context)
		}
	}

	public func updateCocoaView(_ content: Content, context: Context) {
		_PerceptionLocals.$skipPerceptionChecking.withValue(true) {
			update(content, context)
		}
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public func sizeThatFits(
		_ proposal: ProposedViewSize,
		cocoaView content: Content,
		context: Context
	) -> CGSize? {
		_PerceptionLocals.$skipPerceptionChecking.withValue(true) {
			sizeThatFits(
				.init(proposal),
				content,
				context
			)
		}
	}

	public func makeCoordinator() -> Coordinator {
		_PerceptionLocals.$skipPerceptionChecking.withValue(true) {
			coordinator()
		}
	}
}

public struct _CocoaViewControllerRepresentable<Content: CocoaViewController, Coordinator>: CocoaViewControllerRepresentable {
	@_spi(Internals)
	public let content: (Context) -> Content

	@_spi(Internals)
	public let update: (Content, Context) -> Void

	@_spi(Internals)
	public let sizeThatFits: (_ProposedViewSizeDTO, Content, Context) -> CGSize?

	@_spi(Internals)
	public let coordinator: () -> Coordinator

	@_spi(Internals)
	public init(
		content: @escaping (Context) -> Content,
		update: @escaping (Content, Context) -> Void,
		sizeThatFits: @escaping (_ProposedViewSizeDTO, Content, Context) -> CGSize? = { _, _, _ in nil },
		coordinator: @escaping () -> Coordinator
	) {
		self.content = content
		self.update = update
		self.sizeThatFits = sizeThatFits
		self.coordinator = coordinator
	}

	public func makeCocoaViewController(context: Context) -> Content {
		_PerceptionLocals.$skipPerceptionChecking.withValue(true) {
			content(context)
		}
	}

	public func updateCocoaViewController(_ content: Content, context: Context) {
		_PerceptionLocals.$skipPerceptionChecking.withValue(true) {
			update(content, context)
		}
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public func sizeThatFits(
		_ proposal: ProposedViewSize,
		cocoaViewController content: Content,
		context: Context
	) -> CGSize? {
		_PerceptionLocals.$skipPerceptionChecking.withValue(true) {
			sizeThatFits(
				.init(proposal),
				content,
				context
			)
		}
	}

	public func makeCoordinator() -> Coordinator {
		_PerceptionLocals.$skipPerceptionChecking.withValue(true) {
			coordinator()
		}
	}
}

// MARK: - View initializers

extension CocoaComponent {
	public init<
		Content: CocoaView,
		Coordinator
	>(
		content: @escaping (Representable.Context) -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewRepresentable<Content, Coordinator> {
		self.init(content: {
			Representable(
				content: content,
				update: update,
				coordinator: coordinator
			)
		})
	}

	public init<
		Content: CocoaView,
		Coordinator
	>(
		content: @escaping () -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewRepresentable<Content, Coordinator> {
		self.init(
			content: { _ in content() },
			update: update,
			coordinator: coordinator
		)
	}

	public init<
		Content: CocoaView,
		Coordinator
	>(
		_ content: @escaping @autoclosure () -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewRepresentable<Content, Coordinator> {
		self.init(
			content: content,
			update: update,
			coordinator: coordinator
		)
	}

	public init<Content: CocoaView>(
		content: @escaping (Representable.Context) -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in }
	) where Representable == _CocoaViewRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			coordinator: {}
		)
	}

	public init<Content: CocoaView>(
		content: @escaping () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in }
	) where Representable == _CocoaViewRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			coordinator: {}
		)
	}

	public init<Content: CocoaView>(
		_ content: @escaping @autoclosure () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in }
	) where Representable == _CocoaViewRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			coordinator: {}
		)
	}
}

// MARK: Size-providing

extension CocoaComponent {
	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<
		Content: CocoaView,
		Coordinator
	>(
		content: @escaping (Representable.Context) -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewRepresentable<Content, Coordinator> {
		self.init(content: {
			Representable(
				content: content,
				update: update,
				sizeThatFits: { sizeThatFits($0.proposal, $1, $2) },
				coordinator: coordinator
			)
		})
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<
		Content: CocoaView,
		Coordinator
	>(
		content: @escaping () -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewRepresentable<Content, Coordinator> {
		self.init(
			content: { _ in content() },
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: coordinator
		)
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<
		Content: CocoaView,
		Coordinator
	>(
		_ content: @escaping @autoclosure () -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewRepresentable<Content, Coordinator> {
		self.init(
			content: content,
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: coordinator
		)
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<Content: CocoaView>(
		content: @escaping (Representable.Context) -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in },
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?
	) where Representable == _CocoaViewRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: {}
		)
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<Content: CocoaView>(
		content: @escaping () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in },
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?
	) where Representable == _CocoaViewRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: {}
		)
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<Content: CocoaView>(
		_ content: @escaping @autoclosure () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in },
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?
	) where Representable == _CocoaViewRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: {}
		)
	}
}

// MARK: - Controller initializers

extension CocoaComponent {
	public init<
		Content: CocoaViewController,
		Coordinator
	>(
		content: @escaping (Representable.Context) -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewControllerRepresentable<Content, Coordinator> {
		self.init(content: {
			Representable(
				content: content,
				update: update,
				coordinator: coordinator
			)
		})
	}

	public init<
		Content: CocoaViewController,
		Coordinator
	>(
		content: @escaping () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in },
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewControllerRepresentable<Content, Void> {
		self.init(
			content: { _ in content() },
			update: update,
			coordinator: {}
		)
	}

	public init<
		Content: CocoaViewController,
		Coordinator
	>(
		_ content: @escaping @autoclosure () -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewControllerRepresentable<Content, Coordinator> {
		self.init(
			content: { _ in content() },
			update: update,
			coordinator: coordinator
		)
	}

	public init<Content: CocoaViewController>(
		content: @escaping (Representable.Context) -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in }
	) where Representable == _CocoaViewControllerRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			coordinator: {}
		)
	}

	public init<Content: CocoaViewController>(
		_ content: @escaping () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in }
	) where Representable == _CocoaViewControllerRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			coordinator: {}
		)
	}

	public init<Content: CocoaViewController>(
		_ content: @escaping @autoclosure () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in }
	) where Representable == _CocoaViewControllerRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			coordinator: {}
		)
	}
}

// MARK: Size-providing

extension CocoaComponent {
	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<
		Content: CocoaViewController,
		Coordinator
	>(
		content: @escaping (Representable.Context) -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewControllerRepresentable<Content, Coordinator> {
		self.init(content: {
			Representable(
				content: content,
				update: update,
				sizeThatFits: { sizeThatFits($0.proposal, $1, $2) },
				coordinator: coordinator
			)
		})
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<
		Content: CocoaViewController,
		Coordinator
	>(
		content: @escaping () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in },
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewControllerRepresentable<Content, Void> {
		self.init(
			content: { _ in content() },
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: {}
		)
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<
		Content: CocoaViewController,
		Coordinator
	>(
		_ content: @escaping @autoclosure () -> Content,
		update: @escaping (Content, Representable.Context) -> Void,
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?,
		coordinator: @escaping () -> Coordinator
	) where Representable == _CocoaViewControllerRepresentable<Content, Coordinator> {
		self.init(
			content: { _ in content() },
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: coordinator
		)
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<Content: CocoaViewController>(
		content: @escaping (Representable.Context) -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in },
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?
	) where Representable == _CocoaViewControllerRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: {}
		)
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<Content: CocoaViewController>(
		_ content: @escaping () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in },
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?
	) where Representable == _CocoaViewControllerRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: {}
		)
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init<Content: CocoaViewController>(
		_ content: @escaping @autoclosure () -> Content,
		update: @escaping (Content, Representable.Context) -> Void = { _, _ in },
		sizeThatFits: @escaping (ProposedViewSize, Content, Representable.Context) -> CGSize?
	) where Representable == _CocoaViewControllerRepresentable<Content, Void> {
		self.init(
			content: content,
			update: update,
			sizeThatFits: sizeThatFits,
			coordinator: {}
		)
	}
}

// MARK: - DTOs

@_spi(Internals)
public struct _ProposedViewSizeDTO {
	public let width: CGFloat?
	public let height: CGFloat?

	public init(width: CGFloat?, height: CGFloat?) {
		self.width = width
		self.height = height
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	public init(_ proposal: ProposedViewSize) {
		self.width = proposal.width
		self.height = proposal.height
	}

	@available(iOS 16.0, macOS 13.0, tvOS 16.0, watchOS 9.0, *)
	var proposal: ProposedViewSize {
		.init(width: width, height: height)
	}
}

#endif
