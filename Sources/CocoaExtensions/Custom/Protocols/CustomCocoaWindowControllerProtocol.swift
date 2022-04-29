#if canImport(AppKit)
import CocoaAliases
import FunctionalClosures

public protocol CustomCocoaWindowControllerProtocol:
  NSWindowController,
  CustomNSObjectProtocol
{
  var onWindowWillLoad: Handler<Void>.Container { get set }
  var onWindowDidLoad: Handler<Void>.Container { get set }
}
#endif
