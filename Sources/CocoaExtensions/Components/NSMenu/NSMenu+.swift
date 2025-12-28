#if os(macOS)
import Cocoa

extension NSMenu {
	public convenience init(title: String = "Menu", items: [NSMenuItem]) {
		self.init(title: title)
		items.forEach(addItem)
	}
	
	public func popup(for view: NSView) {
		NSMenu.popUpContextMenu(self, with: NSEvent(), for: view)
	}
}

extension NSMenu {
	public struct Submenu: NSMenuAttachableItem {
		public init(
			_ title: String,
			shortcut: NSMenuItem.KeyEquivalent? = nil,
			@MenuItemsBuilder content: () -> NSMenuAttachableItem
		) {
			self.title = title
			self.shortcut = shortcut
			self.content = content()
		}

		let title: String
		let shortcut: NSMenuItem.KeyEquivalent?
		let content: NSMenuAttachableItem

		@discardableResult
		public func attach(to menu: NSMenu) -> [NSMenuItem] {
			let submenuItem = NSMenuItem(title, shortcut: shortcut, action: {})
			submenuItem.attach(to: menu)
			let submenu = NSMenu()
			content.attach(to: submenu)
			menu.setSubmenu(submenu, for: submenuItem)
			return [submenuItem]
		}
	}
}
#endif
