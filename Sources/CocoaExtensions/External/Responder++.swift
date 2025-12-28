//
// Copyright (c) Vatsal Manot
//

#if os(iOS) || os(tvOS) || targetEnvironment(macCatalyst)

import Swift
import UIKit
import FoundationExtensions

extension UIResponder {
	var globalFrame: CGRect? {
		guard let view = self as? UIView else {
			return nil
		}
		
		return view.superview?.convert(view.frame, to: nil)
	}
}

extension UIResponder {
	private static weak var _firstResponder: UIResponder?
	
	@available(macCatalystApplicationExtension, unavailable)
	@available(iOSApplicationExtension, unavailable)
	@available(tvOSApplicationExtension, unavailable)
	static var firstResponder: UIResponder? {
		_firstResponder = nil
		
		UIApplication.shared.sendAction(
			#selector(UIResponder.acquireFirstResponder(_:)),
			to: nil,
			from: nil,
			for: nil
		)
		
		return _firstResponder
	}
	
	@objc private func acquireFirstResponder(_ sender: Any) {
		UIResponder._firstResponder = self
	}
}

extension UIResponder {
	public func nearestResponder<Responder: UIResponder>(
		ofType type: Responder.Type
	) -> Responder? {
		guard !self.is(type)
		else { return (self as! Responder) }
		
		return next?.nearestResponder(ofType: type)
	}
	
	private func furthestResponder<Responder: UIResponder>(
		ofType type: Responder.Type,
		default _default: Responder?
	) -> Responder? {
		return next?.furthestResponder(
			ofType: type,
			default: self as? Responder
		).or(_default)
	}
	
	public func furthestResponder<Responder: UIResponder>(
		ofType type: Responder.Type
	) -> Responder? {
		return furthestResponder(
			ofType: type,
			default: nil
		)
	}
	
	public func forEach<Responder: UIResponder>(
		ofType type: Responder.Type,
		recursive iterator: (Responder) throws -> Void
	) rethrows {
		if self.is(type) {
			try iterator(self as! Responder)
		}
		
		try next?.forEach(ofType: type, recursive: iterator)
	}
}

extension UIResponder {
	@objc open var nearestViewController: UIViewController? {
		nearestResponder(ofType: UIViewController.self)
	}
	
	@objc open var furthestViewController: UIViewController? {
		furthestResponder(ofType: UIViewController.self)
	}
	
	@objc open var nearestNavigationController: UINavigationController? {
		nearestResponder(ofType: UINavigationController.self)
	}
	
	@objc open var furthestNavigationController: UINavigationController? {
		furthestResponder(ofType: UINavigationController.self)
	}
}

#endif
