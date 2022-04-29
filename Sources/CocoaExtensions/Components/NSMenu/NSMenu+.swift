#if canImport(AppKit)
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
#endif
