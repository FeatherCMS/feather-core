//
//  File.swift
//
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import XCTest
@testable import FeatherCliGenerator

final class ApiModuleGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        let descriptor = ModuleDescriptor(name: "User", models: [])
        
        let result = ApiModuleGenerator(descriptor).generate()
        let expectation = """
            public enum User: FeatherApiModule {}
            """

        XCTAssertEqual(expectation, result)
    }
}
