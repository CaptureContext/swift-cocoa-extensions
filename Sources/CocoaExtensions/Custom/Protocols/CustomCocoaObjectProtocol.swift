#if canImport(Darwin)
import Foundation

@available(*, deprecated, renamed: "CustomCocoaObjectProtocol")
public typealias CustomNSObjectProtocol = CustomCocoaObjectProtocol

@MainActor
public protocol CustomCocoaObjectProtocol: NSObject {
	/// Only for `override` purposes, do not call directly
	func _init()
}
#endif
