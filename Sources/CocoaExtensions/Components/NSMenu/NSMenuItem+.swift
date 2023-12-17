#if os(macOS)
import CocoaAliases

extension NSMenuItem {
	public struct KeyEquivalent: Equatable {
		public let value: String
		public let modifiers: NSEvent.ModifierFlags?
		
		public init?(_ value: String, modifiers: NSEvent.ModifierFlags? = nil) {
			guard value.isNotEmpty else { return nil }
			self.value = value
			self.modifiers = modifiers
		}
	}
	
	public convenience init(
		_ title: String,
		shortcut: KeyEquivalent? = nil,
		action: @escaping () -> Void
	) {
		class Handler {
			private var _action: () -> Void
			
			init(_ action: @escaping () -> Void) {
				self._action = action
			}
			
			@objc private func action() { _action() }
			var selector: Selector { #selector(action) }
		}
		
		let handler = Handler(action)
		
		self.init(
			title: title,
			action: handler.selector,
			keyEquivalent: shortcut.map(\.value).or("")
		)
		
		shortcut.flatMap(\.modifiers)
			.map { self.keyEquivalentModifierMask = $0 }
		
		self.target = handler
		setAssociatedObject(handler, forKey: "handler")
	}
}

extension NSMenuItem.KeyEquivalent: ExpressibleByStringLiteral {
	public init(stringLiteral value: String) {
		guard let shortcut = Self.init(value)
		else { preconditionFailure() }
		self = shortcut
	}
	
	public func modifiers(
		_ modifiers: NSEvent.ModifierFlags...
	) -> NSMenuItem.KeyEquivalent {
		return self.modifiers(modifiers.merge())
	}
	
	public func modifiers(
		_ modifiers: NSEvent.ModifierFlags? = nil
	) -> NSMenuItem.KeyEquivalent {
		guard let shortcut = Self.init(value, modifiers: modifiers)
		else { preconditionFailure() }
		return shortcut
	}
}

extension Array where Element == NSEvent.ModifierFlags {
	fileprivate func merge() -> NSEvent.ModifierFlags? {
		guard var flag = first else { return nil }
		dropFirst().forEach { flag.insert($0) }
		return flag
	}
}

extension NSEvent.ModifierFlags {
	public static func +(_ lhs: Self, rhs: String) -> NSMenuItem.KeyEquivalent? {
		return .init(rhs, modifiers: lhs)
	}
}

#endif
