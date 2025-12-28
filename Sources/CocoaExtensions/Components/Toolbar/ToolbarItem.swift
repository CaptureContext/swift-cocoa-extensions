#if os(macOS)
import CocoaAliases
import FoundationExtensions
import DeclarativeConfiguration

public protocol ToolbarItemProtocol: NSToolbarItem {
	var onAction: (() -> Void)? { get }
	var isSelectable: Bool { get }
}

extension ToolbarItemProtocol {
	public var id: NSToolbarItem.Identifier { itemIdentifier }
}

public protocol ToolbarItemGroupProtocol: NSToolbarItemGroup, ToolbarItemProtocol {}

public class SidebarTrackingToolbarItem: NSTrackingSeparatorToolbarItem, ToolbarItemProtocol, Identifiable {
	public typealias ID = Identifier
	
	public var isSelectable: Bool { false }
	
	public convenience init(
		_ identifier: NSToolbarItem.Identifier,
		config: (Config) -> Config = { $0 }
	) {
		self.init(itemIdentifier: identifier)
		config(Config()).configure(self)
	}
	
	public override init(itemIdentifier: NSToolbarItem.Identifier) {
		super.init(itemIdentifier: itemIdentifier)
		self.target = self
		self.action = #selector(__action)
	}
	
	public var onAction: (() -> Void)?
	
	@objc
	private func __action() { onAction?() }
}

public class ToolbarItem: NSToolbarItem, ToolbarItemProtocol, Identifiable {
	public typealias ID = Identifier
	
	public var isSelectable: Bool = false
	
	public convenience init(
		_ identifier: NSToolbarItem.Identifier,
		config: (Config) -> Config = { $0 }
	) {
		self.init(itemIdentifier: identifier)
		config(Config()).configure(self)
	}
	
	public override init(itemIdentifier: NSToolbarItem.Identifier) {
		super.init(itemIdentifier: itemIdentifier)
		self.target = self
		self.action = #selector(__action)
	}
	
	public var onAction: (() -> Void)?
	
	@objc
	private func __action() { onAction?() }
}

public class ToolbarItemGroup: NSToolbarItemGroup, ToolbarItemGroupProtocol, Identifiable {
	public typealias ID = Identifier
	
	public var isSelectable: Bool { false }
	
	public override var subitems: [NSToolbarItem] {
		get { super.subitems }
		set {
			assert(newValue.allSatisfy { $0 is ToolbarItemProtocol })
			super.subitems = newValue.compactMap { $0 as? ToolbarItemProtocol }
		}
	}
	
	public convenience init(
		_ identifier: NSToolbarItem.Identifier,
		subitems: [ToolbarItemProtocol] = [],
		config: (Config) -> Config = { $0 }
	) {
		self.init(itemIdentifier: identifier)
		super.subitems = subitems
		config(Config()).configure(self)
	}
	
	public override init(itemIdentifier: NSToolbarItem.Identifier) {
		super.init(itemIdentifier: itemIdentifier)
		self.target = self
		self.action = #selector(__action)
	}
	
	public var onAction: (() -> Void)?
	
	@objc
	private func __action() { onAction?() }
}
#endif
