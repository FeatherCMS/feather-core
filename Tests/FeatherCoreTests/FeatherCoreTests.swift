import XCTest
import XCTVapor
import Spec
import FluentSQLiteDriver
import LiquidLocalDriver

@testable import FeatherCore

final class FeatherCoreTests: XCTestCase {
    
    private func featherInstall() throws {
//        let feather = try Feather(env: .testing)
//
//        feather.usePublicFileMiddleware()
//        feather.use(database: .sqlite(.memory), databaseId: .sqlite)
//        feather.use(fileStorage: .local(publicUrl: Application.baseUrl, publicPath: Application.Paths.public.path, workDirectory: "assets"), fileStorageId: .local)
//        try feather.configure()
//
//        try feather.app.describe("System install must succeed")
//            .get("/install/")
//            .expect(.ok)
//            .expect(.html)
//            .test(.inMemory)
//
//        return feather
    }
    
    func testSystemInstall() throws {
//        let feather = try featherInstall()
//        defer { feather.stop() }
//
//        try feather.app.describe("Welcome page must present after install")
//            .get("/")
//            .expect(.ok)
//            .expect(.html)
//            .expect { value in
//                XCTAssertTrue(value.body.string.contains("Welcome"))
//            }
//            .test(.inMemory)
    }
    
    private func sample() {
//        let baseUrl = #file.split(separator: "/").dropLast().joined(separator: "/")
//        let filePath = baseUrl + "/.env.testing"
//        let env = Environment.testing
//
//
//        let fileio = NonBlockingFileIO(threadPool: pool)
//        let file = try DotEnvFile.read(path: filePath, fileio: fileio, on: elg.next()).wait()
//
//        let bucketValue = file.lines.first { $0.key == "BUCKET" }.map { $0.value } ?? ""
//        let regionValue = file.lines.first { $0.key == "REGION" }.map { $0.value } ?? ""
//        let regionType: Region? = Region(rawValue: regionValue)
//
//        guard let region = regionType else {
//            fatalError("Invalid `.env.testing` configuration.")
//        }
//        let bucket = S3.Bucket(name: bucketValue)
//        guard bucket.hasValidName() else {
//            fatalError("Invalid Bucket name in the config file.")
//        }
//        try feather.app
//            .test(.GET, "/install/") { res in XCTAssertEqual(res.status.code, 200) }
//            .test(.GET, "/") { res in XCTAssertEqual(res.status.code, 200) }
    }
}
