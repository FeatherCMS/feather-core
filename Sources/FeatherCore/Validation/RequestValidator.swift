//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 02..
//

public struct RequestValidator {

    public var validators: [AsyncValidator]
    
    public init(_ validators: [AsyncValidator] = []) {
        self.validators = validators
    }

    /// this is magic, don't touch it
    public func validate(_ req: Request, message: String? = nil) async throws {
        var result: [ValidationErrorDetail] = []
        try await validators.forEachAsync { validator in
            /// skip if the final result contains an error with an existing key
            if result.contains(where: { $0.key == validator.key }) {
                return
            }
            if let res = try await validator.validate(req) {
                result.append(res)
            }
        }
        if !result.isEmpty {
            throw ValidationAbort(abort: Abort(.badRequest, reason: message), details: result)
        }
    }

    public func isValid(_ req: Request) async -> Bool {
        do {
            try await validate(req, message: nil)
            return true
        }
        catch {
            return false
        }
    }
}
