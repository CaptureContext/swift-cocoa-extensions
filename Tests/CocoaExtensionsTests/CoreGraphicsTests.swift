import XCTest
@testable import CocoaExtensions

final class CoreGraphicsTests: XCTestCase {
	func testCGSize_square() {
		XCTAssertEqual(CGSize.square(0), CGSize.zero)
		XCTAssertEqual(CGSize.square(100), CGSize(width: 100, height: 100))
	}

	func testCGSize_initWithPoint() {
		XCTAssertEqual(CGSize(CGPoint.zero), CGSize.zero)
		XCTAssertEqual(CGSize(CGPoint(x: 100, y: 100)), CGSize(width: 100, height: 100))
	}

	func testCGPoint_initWithSize() {
		XCTAssertEqual(CGPoint(CGSize.zero), CGPoint.zero)
		XCTAssertEqual(CGPoint(CGSize(width: 100, height: 100)), CGPoint(x: 100, y: 100))
	}

	func testCGSize_center() {
		XCTAssertEqual(CGSize.zero.center, CGPoint.zero)
		XCTAssertEqual(CGSize(width: 100, height: 100).center, CGPoint(x: 50, y: 50))
	}
}
