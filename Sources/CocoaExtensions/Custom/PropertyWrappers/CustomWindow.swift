#if canImport(AppKit)
import CocoaAliases

/// The protocol allows to track when the window is loaded using @CustomWindow  propertyWrapper
public protocol CustomLoadableWindow: CocoaView {
  func didLoad(to controller: NSWindowController)
}

@propertyWrapper
public struct CustomWindow<Window: CocoaWindow>: CustomReflectable {
  public static subscript<Controller: NSWindowController>(
    _enclosingInstance controller: Controller,
    wrapped wrappedKeyPath: ReferenceWritableKeyPath<Controller, Window>,
    storage storageKeyPath: ReferenceWritableKeyPath<Controller, Self>
  ) -> Window {
    get {
      guard let _window = controller[keyPath: \.window] else {
        if !controller.tryLoadCustomWindow() {
          assertionFailure("Could not load custom window")
        }
        
        let window = Window()
        controller[keyPath: storageKeyPath].load(window, to: controller)
        return window
      }
      
      guard let window = _window.as(Window.self) else {
        assertionFailure(
          "Call `_instance.load(window:to:)` in" +
          "`NSWindowController.loadWindow` method to setup CustomView properly"
        )
        
        let window = Window()
        controller[keyPath: storageKeyPath].load(window, to: controller)
        return window
      }
      return window
    }
    set {
      controller[keyPath: storageKeyPath].load(newValue, to: controller)
    }
  }
  
  public var customMirror: Mirror {
    Mirror(self, children: [("loadWindow", { load(to: $0) })])
  }
  
  public init() {}
  
  @available(*, unavailable, message: "@CustomWindow can only be applied to classes")
  public var wrappedValue: Window {
    get { fatalError() }
    set { fatalError() }
  }
  
  public func load(
    _ managedWindow: Window = .init(),
    to controller: NSWindowController
  ) {
    controller.window = managedWindow
    managedWindow.as(CustomLoadableWindow.self).map { window in
      window.didLoad(to: controller)
    }
  }
}

extension NSWindowController {
  @discardableResult
  public func tryLoadCustomWindow() -> Bool {
    guard
      let _managedWindow = Mirror(reflecting: self).children.first(where: { $0.label == "_managedWindow" })?.value,
      let loadWindow = Mirror(reflecting: _managedWindow).children.first(where: { $0.label == "loadWindow" })?.value,
      let loadWindowTo = loadWindow as? ((NSWindowController) -> Void)
    else { return false }
    loadWindowTo(self)
    return true
  }
}
#endif
