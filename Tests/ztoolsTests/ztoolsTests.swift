import XCTest
@testable import ztools

final class ztoolsTests: XCTestCase {
    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct
        // results.
        XCTAssertEqual(ztools().text, "Hello, World!")
    }

    static var allTests = [
        ("testExample", testExample),
    ]
}
