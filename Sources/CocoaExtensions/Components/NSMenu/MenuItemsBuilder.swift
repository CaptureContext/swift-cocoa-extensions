#if os(macOS)
import CocoaAliases

public protocol NSMenuAttachableItem {
	@discardableResult
	func attach(to menu: NSMenu) -> [NSMenuItem]
}

public struct AnyNSMenuAttachableItem: NSMenuAttachableItem {
	public init(_ item: NSMenuAttachableItem) {
		self.init(attach: item.attach)
	}
	
	public init(attach: @escaping (NSMenu) -> [NSMenuItem]) {
		self._attach = attach
	}
	
	let _attach: (NSMenu) -> [NSMenuItem]
	@discardableResult
	public func attach(to menu: NSMenu) -> [NSMenuItem] {
		_attach(menu)
	}
}

@resultBuilder
public struct MenuItemsBuilder {
	public static func buildBlock(
		_ components: NSMenuAttachableItem...
	) -> NSMenuAttachableItem {
		buildArray(components)
	}
	
	public static func buildArray(_ components: [NSMenuAttachableItem]) -> NSMenuAttachableItem {
		AnyNSMenuAttachableItem { menu in
			components.flatMap { component in
				component.attach(to: menu)
			}
		}
	}
	
	public static func buildOptional(
		_ component: NSMenuAttachableItem?
	) -> NSMenuAttachableItem {
		AnyNSMenuAttachableItem { menu in
			component?.attach(to: menu) ?? []
		}
	}
	
	public static func buildEither(
		first component: NSMenuAttachableItem
	) -> NSMenuAttachableItem { component }
	
	public static func buildEither(
		second component: NSMenuAttachableItem
	) -> NSMenuAttachableItem { component }
	
	public static func buildLimitedAvailability(
		_ component: NSMenuAttachableItem
	) -> NSMenuAttachableItem { component }
}

extension NSMenu {
	public convenience init(
		_ title: String? = nil,
		@MenuItemsBuilder content: () -> NSMenuAttachableItem
	) {
		if let title = title {
			self.init(title: title)
		} else {
			self.init()
		}
		content().attach(to: self)
	}
}

extension NSMenuItem: NSMenuAttachableItem {
	@discardableResult
	public func attach(
		to menu: NSMenu
	) -> [NSMenuItem] {
		menu.addItem(self)
		return [self]
	}
}
#endif
