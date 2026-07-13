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
	private func _observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?,
		value: @escaping (UITraitCollection, Trait.Type) -> Trait.Value
	) -> (any UITraitChangeRegistration)? {
		guard let handler else {
			activeTraitRegistrations[ObjectIdentifier(Trait.self)] = nil
			return nil
		}

		let registration = self.registerForTraitChanges(
			[Trait.self]
		) { (_self: Self, _: UITraitCollection) in
			handler(_self, value(_self.traitCollection, Trait.self))
		}

		activeTraitRegistrations[ObjectIdentifier(Trait.self)] = registration
		return registration
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)? where Trait.Value == CGFloat {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)? where Trait.Value == CGFloat? {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)? where Trait.Value == Double {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)? where Trait.Value == Double? {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)? where Trait.Value == Int {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)? where Trait.Value == Int? {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)? where Trait.Value == Bool {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)?
	where Trait.Value: RawRepresentable {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)?
	where Trait.Value: RawRepresentable, Trait.Value.RawValue == CGFloat {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)?
	where Trait.Value: RawRepresentable, Trait.Value.RawValue == Double {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)?
	where Trait.Value: RawRepresentable, Trait.Value.RawValue == Int {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}

	@discardableResult
	public func observeTrait<Trait: UITraitDefinition>(
		_ trait: Trait.Type,
		handler: ((Self, Trait.Value) -> Void)?
	) -> (any UITraitChangeRegistration)? {
		self._observeTrait(trait, handler: handler) { collection, trait in
			collection[trait]
		}
	}
}
#endif
