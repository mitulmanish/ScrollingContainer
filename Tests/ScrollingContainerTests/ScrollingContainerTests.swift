import XCTest
@testable import ScrollingContainer

final class ScrollingContainerTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ScrollingContainer().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
