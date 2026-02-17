#if !os(watchOS) && canImport(Darwin)
import CocoaAliases

@MainActor
public protocol CustomCocoaViewProtocol: CocoaView, CustomCocoaObjectProtocol {}
#endif
