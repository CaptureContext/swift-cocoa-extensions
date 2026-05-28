#if canImport(UIKit)
import CocoaAliases
import AssociatedObjects

@available(iOS 17.0, tvOS 17.0, *)
@available(watchOS, unavailable)
extension UITraitChangeObservable
where Self: NSObject & UITraitEnvironment {
	private var activeTraitRegistrations: [
		AnyHashable: (any UITraitChangeRegistration)
	] {
		get {
			getAssociatedObject(forKey: #function) ?? {
				let value: [AnyHashable: (any UITraitChangeRegistration)] = [:]
				setAssociatedObject(value, forKey: #function)
				return value
			}()
		}
		set {
			setAssociatedObject(newValue, forKey: #function)
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)? {
		guard let handler else {
			activeTraitRegistrations[ObjectIdentifier(Trait.self)] = nil
			return nil
		}

		let registration = self.registerForTraitChanges(
			[Trait.self]
		) { (_self: Self, collection: UITraitCollection) in
			handler(_self, self.traitCollection[Trait.self])
		}

		activeTraitRegistrations[ObjectIdentifier(Trait.self)] = registration
		return registration
	}
}
#endif
