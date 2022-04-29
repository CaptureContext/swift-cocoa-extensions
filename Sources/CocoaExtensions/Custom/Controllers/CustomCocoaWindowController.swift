#if canImport(AppKit)
import CocoaAliases
import FunctionalClosures

public protocol CustomWindowProvider: NSWindowController {
  associatedtype Window: CocoaWindow
  var managedWindow: Window { get set }
}

open class CustomWindowController:
  NSWindowController,
  CustomCocoaWindowControllerProtocol
{
  @Handler<Void>
  public var onWindowWillLoad
  
  @Handler<Void>
  public var onWindowDidLoad
  
  public override init(window: CocoaWindow?) {
    super.init(window: window)
    self._init()
  }
  
  public required init?(coder: NSCoder) {
    super.init(coder: coder)
    self._init()
  }
  
  open func _init() {}
  
  open override func loadWindow() {
    if !tryLoadCustomWindow() {
      super.loadWindow()
    }
  }
  
  open override func windowWillLoad() {
    super.windowWillLoad()
    _onWindowWillLoad()
  }
  
  open override func windowDidLoad() {
    super.windowDidLoad()
    _onWindowDidLoad()
  }
}
#endif
