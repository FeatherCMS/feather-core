//
//  RedirectRuleApi.swift
//  
//
//  Created by Steve Tibbett on 2021-12-19
//

import Vapor
import AppKit

extension RedirectRule.List: Content {}
extension RedirectRule.Detail: Content {}
extension RedirectRule.Create: Content {}
extension RedirectRule.Update: Content {}
extension RedirectRule.Patch: Content {}

struct RedirectRuleApi: FeatherApi {
    typealias Model = RedirectRuleModel

    func mapList(_ req: Request, model: Model) async throws -> RedirectRule.List {
        .init(id: model.uuid,
              source: model.source,
              destination: model.destination,
              statusCode: model.statusCode,
              notes: model.notes)
    }
    
    func mapDetail(_ req: Request, model: Model) async throws -> RedirectRule.List {
        return .init(id: model.id!,
                     source: model.source,
                     destination: model.destination,
                     statusCode: model.statusCode,
                     notes: model.notes)
    }
    
    func mapCreate(_ req: Request, model: Model, input: RedirectRule.Create) async throws {
        model.source = input.source
        model.destination = input.destination
        model.statusCode = input.statusCode
        model.notes = input.notes
    }
    
    func mapUpdate(_ req: Request, model: Model, input: RedirectRule.Update) async throws {
        model.source = input.source
        model.destination = input.destination
        model.statusCode = input.statusCode
        model.notes = input.notes
    }
    
    func mapPatch(_ req: Request, model: Model, input: RedirectRule.Patch) async throws {
        model.source = input.source
        model.destination = input.destination
        model.statusCode = input.statusCode
        model.notes = input.notes
    }
    
    func validators(optional: Bool) -> [AsyncValidator] {
        []
    }
}
