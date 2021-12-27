//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 18..
//

import XCTest
@testable Sdk

final class UserApiTests: XCTestCase {

    func testRoutes() async throws {
        
        let url = URL(string: "https://jsonplaceholder.typicode.com/todos/1")!
        let result = try await HTTP.Request(method: .get, url: url).perform()
        print(result.statusCode)
    }
}
