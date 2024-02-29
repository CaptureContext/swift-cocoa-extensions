import CocoaAliases

public protocol SupplimentaryItemKindProvidingType {
	static var supplimentaryItemKind: String { get }
}

public protocol ReuseIDProvidingType {
	static var reuseID: String { get }
}

extension ReuseIDProvidingType {
	public static var reuseID: String { .init(reflecting: self) }
}

#if !os(watchOS)
extension CocoaCollectionReusableView: ReuseIDProvidingType {}

#if !os(iOS) && !os(tvOS) // handled by CocoaCollectionReusableView
extension CocoaCollectionViewCell: ReuseIDProvidingType {}
#endif

#if !os(macOS) // handled by CocoaCollectionViewCell
extension CocoaTableViewCell: ReuseIDProvidingType {}
#endif
#endif

#if !os(watchOS)
extension CocoaTableView {
	#if canImport(UIKit)
	public func register<
		Cell: CocoaTableViewCell
	>(
		_ type: Cell.Type
	) {
		register(
			type,
			forCellReuseIdentifier: Cell.reuseID
		)
	}
	#endif
	
	public func dequeueReusableCell<
		Cell: CocoaTableViewCell
	>(
		_ type: Cell.Type,
		at indexPath: IndexPath
	) -> Cell! {
		#if canImport(UIKit)
		dequeueReusableCell(
			withIdentifier: Cell.reuseID,
			for: indexPath
		) as? Cell
		#else
		makeView(
			withIdentifier: NSUserInterfaceItemIdentifier(
				rawValue: Cell.reuseID
			),
			owner: self
		) as? Cell
		#endif
	}
}
#endif

#if !os(watchOS)
extension CocoaCollectionView {
	public func registerSupplimentaryItem<
		SupplimentaryItem:
				CocoaCollectionReusableView
	>(
		_ type: SupplimentaryItem.Type?,
		ofKind kind: String
	) {
		#if canImport(UIKit)
		register(
			type,
			forSupplementaryViewOfKind: kind,
			withReuseIdentifier: SupplimentaryItem.reuseID
		)
		#elseif canImport(AppKit)
		register(
			type,
			forSupplementaryViewOfKind: kind,
			withIdentifier: NSUserInterfaceItemIdentifier(
				rawValue: SupplimentaryItem.reuseID
			)
		)
		#endif
	}
	
	public func registerSupplimentaryItem<
		SupplimentaryItem:
				CocoaCollectionReusableView & SupplimentaryItemKindProvidingType
	>(
		_ type: SupplimentaryItem.Type?
	) {
		registerSupplimentaryItem(
			type,
			ofKind: SupplimentaryItem.supplimentaryItemKind
		)
	}
	
	public func register<
		Cell: CocoaCollectionViewCell
	>(
		_ type: Cell.Type?
	) {
		#if canImport(UIKit)
		register(type, forCellWithReuseIdentifier: Cell.reuseID)
		#elseif canImport(AppKit)
		register(
			type,
			forItemWithIdentifier: NSUserInterfaceItemIdentifier(
				Cell.reuseID
			)
		)
		#endif
	}
	
	public func dequeueSupplimentaryItem<
		SupplimentaryItem: ReuseIDProvidingType
	>(
		_ type: SupplimentaryItem.Type = SupplimentaryItem.self,
		ofKind kind: String,
		at indexPath: IndexPath
	) -> SupplimentaryItem! {
		#if canImport(UIKit)
		dequeueReusableSupplementaryView(
			ofKind: kind,
			withReuseIdentifier: SupplimentaryItem.reuseID,
			for: indexPath
		) as? SupplimentaryItem
		#else
		makeSupplementaryView(
			ofKind: kind,
			withIdentifier: NSUserInterfaceItemIdentifier(
				rawValue: SupplimentaryItem.reuseID
			),
			for: indexPath
		) as? SupplimentaryItem
		#endif
	}
	
	public func dequeueSupplimentaryItem<
		SupplimentaryItem: CocoaCollectionReusableView & SupplimentaryItemKindProvidingType
	>(
		_ type: SupplimentaryItem.Type,
		at indexPath: IndexPath
	) -> SupplimentaryItem! {
		dequeueSupplimentaryItem(
			type,
			ofKind: type.supplimentaryItemKind,
			at: indexPath
		)
	}
	
	public func dequeueReusableCell<
		Cell: CocoaCollectionViewCell
	>(
		_ type: Cell.Type = Cell.self,
		at indexPath: IndexPath
	) -> Cell! {
		#if canImport(UIKit)
		dequeueReusableCell(
			withReuseIdentifier: Cell.reuseID,
			for: indexPath
		) as? Cell
		#else
		makeItem(
			withIdentifier: NSUserInterfaceItemIdentifier(
				rawValue: Cell.reuseID
			),
			for: indexPath
		) as? Cell
		#endif
	}
}
#endif
