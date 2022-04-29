#if !os(watchOS)
import CocoaAliases
import FunctionalClosures

#if canImport(AppKit)
public protocol CustomCocoaWindowProtocol: CustomNSObjectProtocol {
  var onClose: Handler<Void>.Container { get set }
}
#elseif canImport(UIKit)
public protocol CustomCocoaWindowProtocol: CustomCocoaViewProtocol {}
#endif
#endif
