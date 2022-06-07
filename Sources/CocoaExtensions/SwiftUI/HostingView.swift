#if canImport(UIKit) && !os(watchOS)
import SwiftUI

open class UIHostingView<RootView: View>: CustomCocoaView {
  public let controller: UIHostingController<RootView>
  
  public convenience init(@ViewBuilder content: () -> RootView) {
    self.init(rootView: content())
  }
  
  public init(rootView: RootView) {
    self.controller = .init(rootView: rootView)
    super.init(frame: .zero)
  }
  
  public override init(frame: CGRect) {
    guard let rootView = Self.tryInitOptionalRootView()
    else { fatalError("Root view is not expressible by nil literal") }
    self.controller = UIHostingController(rootView: rootView)
    super.init(frame: frame)
  }
  
  public required init?(coder: NSCoder) {
    guard let rootView = Self.tryInitOptionalRootView()
    else { fatalError("Root view is not expressible by nil literal") }
    self.controller = UIHostingController(rootView: rootView)
    super.init(coder: coder)
  }
  
  public var rootView: RootView {
    get { controller.rootView }
    set { controller.rootView = newValue }
  }
  
  open override func _init() {
    super._init()
    self.backgroundColor = .clear
    self.controller.view.backgroundColor = .clear
    self.addSubview(controller.view)
  }
  
  open override func layoutSubviews() {
    controller.view.frame = bounds
    controller.view.setNeedsLayout()
  }
  
  open override func didMoveToSuperview() {
    super.didMoveToSuperview()
    nearestViewController.map { parent in
      controller.didMove(toParent: parent)
    }
  }
}

extension UIHostingView {
  fileprivate static func tryInitOptionalRootView() -> RootView? {
    guard
      let rootViewType = RootView.self as? ExpressibleByNilLiteral.Type,
      let rootView = rootViewType.init(nilLiteral: ()) as? RootView
    else { return nil }
    return rootView
  }
}
#endif
