
import Foundation
import XCTest
@testable import ztools


final class zSortTests: XCTestCase {
    
    func test_threeSumAlgorithm() {
        // Answer: [[-1, 0, 1], [-1, -1, 2]]
        
        XCTAssertEqual(Algorithm.threeSum([-1, 0, 1, 2, -1, -4], target: 0), [[-1, -1, 2], [-1, 0, 1]])

        // Answer: [[-1, -1, 2], [-1, 0, 1]]
        XCTAssertEqual(Algorithm.threeSum([-1, -1, -1, -1, 2, 1, -4, 0], target: 0),[[-1, -1, 2], [-1, 0, 1]])

        // Answer: [[-1, -1, 2]]
        XCTAssertEqual(Algorithm.threeSum([-1, -1, -1, -1, -1, -1, 2], target: 0),[[-1, -1, 2]])
    }

    static var allTests = [
        ("test_threeSumAlgorithm", test_threeSumAlgorithm),
    ]
}
