import Foundation

public protocol CustomNSObjectProtocol: NSObject {
	nonisolated func _nonisolatedInit()
}
