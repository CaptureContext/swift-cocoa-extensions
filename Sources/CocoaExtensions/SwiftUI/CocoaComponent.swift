#if canImport(SwiftUI) && !os(watchOS)
import SwiftUI
import CocoaAliases

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
	public let coordinator: () -> Coordinator

	@_spi(Internals)
	public init(
		content: @escaping (Context) -> Content,
		update: @escaping (Content, Context) -> Void,
		coordinator: @escaping () -> Coordinator
	) {
		self.content = content
		self.update = update
		self.coordinator = coordinator
	}

	public func makeCocoaView(context: Context) -> Content {
		content(context)
	}

	public func updateCocoaView(_ content: Content, context: Context) {
		update(content, context)
	}

	public func makeCoordinator() -> Coordinator {
		coordinator()
	}
}

public struct _CocoaViewControllerRepresentable<Content: CocoaViewController, Coordinator>: CocoaViewControllerRepresentable {
	@_spi(Internals)
	public let content: (Context) -> Content

	@_spi(Internals)
	public let update: (Content, Context) -> Void

	@_spi(Internals)
	public let coordinator: () -> Coordinator

	@_spi(Internals)
	public init(
		content: @escaping (Context) -> Content,
		update: @escaping (Content, Context) -> Void,
		coordinator: @escaping () -> Coordinator
	) {
		self.content = content
		self.update = update
		self.coordinator = coordinator
	}

	public func makeCocoaViewController(context: Context) -> Content {
		content(context)
	}

	public func updateCocoaViewController(_ content: Content, context: Context) {
		update(content, context)
	}

	public func makeCoordinator() -> Coordinator {
		coordinator()
	}
}

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

#endif
