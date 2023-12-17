#if os(macOS)
import CocoaAliases
import DeclarativeConfiguration
import IdentifiedCollections

public final class CustomToolbar: NSToolbar {
	public static let defaultIdentifier = "custom_toolbar.identifier"
	public let customDelegate = Delegate()
	
	@available(*, deprecated, message: "Use `customDelegate` property")
	public override var delegate: NSToolbarDelegate? {
		get { super.delegate }
		set { super.delegate = newValue }
	}
	
	convenience init() {
		self.init(identifier: CustomToolbar.defaultIdentifier)
	}
	
	public override init(identifier: NSToolbar.Identifier) {
		super.init(identifier: identifier)
		super.delegate = customDelegate
		customDelegate.toolbar = self
	}
	
	public func addItem(_ item: ToolbarItemProtocol) {
		customDelegate.items.append(item)
		super.insertItem(withItemIdentifier: item.id, at: items.count)
	}
	
	public func insertItem(_ item: ToolbarItemProtocol, at index: Int) {
		customDelegate.items.insert(item, at: index)
		super.insertItem(withItemIdentifier: item.id, at: index)
	}
	
	public func addItems(_ items: [ToolbarItemProtocol]) {
		items.forEach(addItem)
	}
	
	public func removeItem(id: NSToolbarItem.Identifier) {
		items.firstIndex { $0.itemIdentifier == id }.map { index in
			super.removeItem(at: index)
		}
		customDelegate.items.remove(id: id)
	}
	
	public func setItems(_ items: [ToolbarItemProtocol]) {
		while self.items.isNotEmpty { super.removeItem(at: 0) }
		customDelegate.items.removeAll()
		addItems(items)
	}
	
	@available(*, deprecated, message: "Use `insertItem(_:at:)` instead")
	public override func insertItem(
		withItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
		at index: Int
	) {
		fatalError("Use `addItem(_:)` instead")
	}
	
	@available(*, deprecated, message: "Use `removeItem(id:)` instead")
	public override func removeItem(at index: Int) {
		fatalError("Use `removeItem(id:)` instead")
	}
}

extension CustomToolbar {
	public class Delegate: NSObject, NSToolbarDelegate {
		weak var toolbar: CustomToolbar?
		
		public var items: IdentifiedArray<
			NSToolbarItem.Identifier,
			ToolbarItemProtocol
		> = .init(id: \.id)
		
		public func toolbar(
			_ toolbar: NSToolbar,
			itemForItemIdentifier itemIdentifier: NSToolbarItem.Identifier,
			willBeInsertedIntoToolbar flag: Bool
		) -> NSToolbarItem? {
			guard toolbar === self.toolbar else { return nil }
			return items[id: itemIdentifier]
		}
		
		public func toolbarDefaultItemIdentifiers(
			_ toolbar: NSToolbar
		) -> [NSToolbarItem.Identifier] {
			return items.map(\.id)
		}
		
		public func toolbarAllowedItemIdentifiers(
			_ toolbar: NSToolbar
		) -> [NSToolbarItem.Identifier] {
			return items.map(\.id)
		}
		
		public func toolbarSelectableItemIdentifiers(
			_ toolbar: NSToolbar
		) -> [NSToolbarItem.Identifier] {
			return items.compactMap { item in
				guard item.isSelectable else { return nil }
				return item.id
			}
		}
	}
}
#endif
