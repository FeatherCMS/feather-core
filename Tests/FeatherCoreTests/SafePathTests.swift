import XCTest
@testable import FeatherCore

final class SafePathTests: XCTestCase {
    
    func testSafePath() throws {
        
        let testCases = [
            "": "/",
            "slug": "/slug/",
            "/multi////characters///": "/multi/characters/",
        ]
        for (test, expectation) in testCases {
            XCTAssertEqual(test.safePath(), expectation)
        }
    }
}
