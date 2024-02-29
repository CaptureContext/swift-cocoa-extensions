#if os(macOS)
import CocoaAliases
import FunctionalClosures

public protocol CustomCocoaWindowControllerProtocol:
	NSWindowController,
	CustomNSObjectProtocol
{
	var onWindowWillLoad: Handler1<Void>.Container { get set }
	var onWindowDidLoad: Handler1<Void>.Container { get set }
}
#endif
