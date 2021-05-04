//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 05. 04..
//

import FeatherCore

public protocol UUIDContent: Content {
    var id: UUID { get }
}

open class FeatherApiTestCase: FeatherTestCase {
    
    open func modelName() -> String {
        fatalError("Must be implemented")
    }

    open func endpoint() -> String {
        fatalError("Must be implemented")
    }
    
    private func fullEndpoint() -> String {
        "/api/admin/" + endpoint() + "/"
    }

    public func list<T: Content>(_ type: T.Type) throws {
        try authenticate()

        try app.describe(modelName() + " list should be available")
            .get(fullEndpoint())
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(PaginationContainer<T>.self)
            .test(.inMemory)
    }

    public func create<I: Content, O: Content>(_ object: I, _ type: O.Type, completion: @escaping ((O) -> Void)) throws {
        try authenticate()

        try app.describe(modelName() + " creation should succeed")
            .post(fullEndpoint())
            .body(object)
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(O.self) { item in
                completion(item)
            }
            .test(.inMemory)
    }
    
    public func createInvalid<I: Content>(_ object: I, completion: @escaping ((ValidationError) -> Void)) throws {
        try authenticate()
        
        try app.describe("Invalid " + modelName() + " shouldn't be created")
            .post(fullEndpoint())
            .body(object)
            .cookie(cookies)
            .expect(.badRequest)
            .expect(.json)
            .expect(ValidationError.self) { error in
                completion(error)
            }
            .test(.inMemory)
    }
    
    public func update<I: Content, U: Content, O: UUIDContent>(_ object: I, _ update: U, _ type: O.Type, completion: @escaping ((O) -> Void)) throws {
        try authenticate()

        var variable: O!

        try app.describe(modelName() + " creation should succeed")
            .post(fullEndpoint())
            .body(object)
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(O.self) { item in
                variable = item
                XCTAssertNotNil(variable)
            }
            .test(.inMemory)
                
        try app.describe(modelName() + " update should succeed")
            .put(fullEndpoint() + "\(variable.id.uuidString)/")
            .body(update)
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(O.self) { item in
                completion(item)
            }
            .test(.inMemory)
    }
    
    public func patch<I: Content, U: Content, O: UUIDContent>(_ object: I, _ update: U, _ type: O.Type, completion: @escaping ((O) -> Void)) throws {
        try authenticate()

        var variable: O!

        try app.describe(modelName() + " creation should succeed")
            .post(fullEndpoint())
            .body(object)
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(O.self) { item in
                variable = item
                XCTAssertNotNil(variable)
            }
            .test(.inMemory)
        
        try app.describe(modelName() + " patch should succeed")
            .patch(fullEndpoint() + "\(variable.id.uuidString)/")
            .body(update)
            .cookie(cookies)
            .expect(.ok)
            .expect(.json)
            .expect(O.self) { item in
                completion(item)
            }
            .test(.inMemory)
    }
    
    public func delete<I: Content, O: UUIDContent>(_ object: I, _ type: O.Type) throws {
        try authenticate()

        var variable: O!

        try app.describe(modelName() + " creation should succeed")
            .post(fullEndpoint())
            .body(object)
            .cookie(cookies)
            .expect(.created)
            .expect(.json)
            .expect(O.self) { item in
                variable = item
                XCTAssertNotNil(variable)
            }
            .test(.inMemory)

        try app.describe(modelName() + " deletion should succeed")
            .delete(fullEndpoint() + "\(variable.id.uuidString)/")
            .cookie(cookies)
            .expect(.noContent)
            .test(.inMemory)
    }
    
    public func deleteMissing() throws {
        try authenticate()
        
        let uuid = UUID().uuidString

        try app.describe("Missing " + modelName() + " deletion should fail")
            .delete(fullEndpoint() + "\(uuid)/")
            .cookie(cookies)
            .expect(.notFound)
            .test(.inMemory)
    }
}

