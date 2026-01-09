#if !os(watchOS)
import CocoaAliases

@MainActor
public protocol CustomCocoaViewProtocol: CocoaView, CustomNSObjectProtocol {}
#endif
