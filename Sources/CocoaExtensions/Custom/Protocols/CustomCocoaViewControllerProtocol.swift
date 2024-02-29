#if !os(watchOS)
import CocoaAliases
import FunctionalClosures

public protocol CustomCocoaViewControllerProtocol:
	CocoaViewController,
	CustomNSObjectProtocol
{
	var isVisible: Bool { get }
	var onDismiss: Handler1<Void>.Container { get set }
	var onViewDidLoad: Handler1<Void>.Container { get set }
	var onViewWillAppear: Handler1<Void>.Container { get set }
	var onViewDidAppear: Handler1<Void>.Container { get set }
	var onViewWillDisappear: Handler1<Void>.Container { get set }
	var onViewDidDisappear: Handler1<Void>.Container { get set }
	var onViewWillLayout: Handler1<Void>.Container { get set }
	var onViewDidLayout: Handler1<Void>.Container { get set }
}
#endif
