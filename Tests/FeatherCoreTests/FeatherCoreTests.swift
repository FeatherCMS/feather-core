import XCTest
@testable import FeatherCore

final class FeatherCoreTests: XCTestCase {
    
    static var allTests = [
        ("testReplaceLastPath", testReplaceLastPath),
    ]

    func testReplaceLastPath() {
        /// test edge cases
        XCTAssertEqual("/bar/", "".replaceLastPath("bar"))
        XCTAssertEqual("/bar/", "/".replaceLastPath("bar"))
        XCTAssertEqual("/bar/", "foo".replaceLastPath("bar"))
        
        /// test leading & trailing slashes
        XCTAssertEqual("/a/b/bar/", "a/b/foo".replaceLastPath("bar"))
        XCTAssertEqual("/a/b/bar/", "/a/b/foo/".replaceLastPath("bar"))
        XCTAssertEqual("/a/b/bar/", "a/b/foo/".replaceLastPath("bar"))
        XCTAssertEqual("/a/b/bar/", "/a/b/foo".replaceLastPath("bar"))
    }
}
