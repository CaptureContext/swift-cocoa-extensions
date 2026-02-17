#if canImport(UIKit) && !os(watchOS)
import CocoaAliases

@available(*, deprecated, message: "Consider migrating to DiffableDataSource")
public class CollectionViewDataSource<
	CellView: CocoaView,
	SupplimentaryView: CocoaView
>: NSObject, CocoaCollectionViewDataSource {
	public var numberOfSections: () -> Int = { 0 }
	public var numberOfItemsInSection: (Int) -> Int = { _ in 0 }

	public var reconfigureCell: (
		CollectionViewCell<CellView>,
		IndexPath
	) -> Void = { _, _ in }

	public var reconfigureSupplimentaryView: (
		CollectionReusableView<SupplimentaryView>,
		String,
		IndexPath
	) -> Void = { _, _, _ in }

	public func collectionView(
		_ collectionView: CocoaCollectionView,
		numberOfItemsInSection section: Int
	) -> Int {
		return numberOfItemsInSection(section)
	}
	
	public func numberOfSections(in collectionView: CocoaCollectionView) -> Int {
		return numberOfSections()
	}
	
	public func collectionView(
		_ collectionView: CocoaCollectionView,
		cellForItemAt indexPath: IndexPath
	) -> CocoaCollectionViewCell {
		let cell = collectionView
			.dequeueReusableCell(
				CollectionViewCell<CellView>.self,
				at: indexPath
			)
			.or(CollectionViewCell<CellView>())

		reconfigureCell(cell, indexPath)
		return cell
	}
	
	public func collectionView(
		_ collectionView: CocoaCollectionView,
		viewForSupplementaryElementOfKind kind: String,
		at indexPath: IndexPath
	) -> CocoaCollectionReusableView {
		let view = collectionView
			.dequeueReusableSupplementaryView(
				ofKind: kind,
				withReuseIdentifier: CollectionReusableView<SupplimentaryView>.reuseID,
				for: indexPath
			)
			.as(CollectionReusableView<SupplimentaryView>.self)
			.or(CollectionReusableView<SupplimentaryView>())

		reconfigureSupplimentaryView(view, kind, indexPath)
		return view
	}
}
#endif
