//
//  SystemVariableModel.swift
//  SystemModule
//
//  Created by Tibor Bödecs on 2020. 06. 10..
//

final class SystemVariableModel: FeatherModel {
    typealias Module = SystemModule

    static let name = "variables"

    struct FieldKeys {
        static var key: FieldKey { "key" }
        static var name: FieldKey { "name" }
        static var value: FieldKey { "value" }
        static var notes: FieldKey { "notes" }
    }

    // MARK: - fields

    @ID() var id: UUID?
    @Field(key: FieldKeys.key) var key: String
    @Field(key: FieldKeys.name) var name: String
    @Field(key: FieldKeys.value) var value: String?
    @Field(key: FieldKeys.notes) var notes: String?

    init() {}

    init(id: UUID? = nil,
         key: String,
         name: String,
         value: String? = nil,
         notes: String? = nil)
    {
        self.id = id
        self.key = key
        self.name = name
        self.value = value
        self.notes = notes
    }
    
    // MARK: - query

    static func allowedOrders() -> [FieldKey] {
        [
            FieldKeys.name,
            FieldKeys.key,
        ]
    }
    
    static func search(_ term: String) -> [ModelValueFilter<SystemVariableModel>] {
        [
            \.$name ~~ term,
            \.$key ~~ term,
            \.$value ~~ term,
            \.$notes ~~ term,
        ]
    }
}
