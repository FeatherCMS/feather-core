@testable import App
import XCTVapor

final class AppTests: XCTestCase {

    func testRoutes() throws {
        let app = Application(.testing)
        defer { app.shutdown() }
        try configure(app)

        try app.test(.GET, "/install/start/") { res in
            XCTAssertEqual(res.status, .ok)
        }
    }
}
