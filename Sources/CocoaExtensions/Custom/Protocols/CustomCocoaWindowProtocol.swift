#if !os(watchOS)
import CocoaAliases
import FunctionalClosures

#if os(macOS)
public protocol CustomCocoaWindowProtocol: CustomNSObjectProtocol {
	var onClose: Handler1<Void>.Container { get set }
}
#elseif canImport(UIKit)
public protocol CustomCocoaWindowProtocol: CustomCocoaViewProtocol {}
#endif
#endif
