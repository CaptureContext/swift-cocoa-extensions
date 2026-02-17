#if canImport(Darwin)
import Testing
@testable import CocoaExtensions

@Suite
struct CoreGraphicsTests {
	@Test
	func cgSize_square() {
		#expect(CGSize.square(0) == CGSize.zero)
		#expect(CGSize.square(100) == CGSize(width: 100, height: 100))
	}

	@Test
	func cgSize_initWithPoint() {
		#expect(CGSize(CGPoint.zero) == CGSize.zero)
		#expect(CGSize(CGPoint(x: 100, y: 100)) == CGSize(width: 100, height: 100))
	}

	@Test
	func cgPoint_initWithSize() {
		#expect(CGPoint(CGSize.zero) == CGPoint.zero)
		#expect(CGPoint(CGSize(width: 100, height: 100)) == CGPoint(x: 100, y: 100))
	}

	@Test
	func cgSize_center() {
		#expect(CGSize.zero.center == CGPoint.zero)
		#expect(CGSize(width: 100, height: 100).center == CGPoint(x: 50, y: 50))
	}
}
#endif
