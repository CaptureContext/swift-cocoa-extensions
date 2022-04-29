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
#endif
