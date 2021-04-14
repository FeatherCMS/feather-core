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

// MARK: - view
 
extension SystemVariableModel: TemplateDataRepresentable {

    var templateData: TemplateData {
        .dictionary([
            "id": id,
            "key": key,
            "name": name,
            "value": value,
            "notes": notes,
        ])
    }
}

// MARK: - api

extension SystemVariableModel: ApiContentRepresentable {

    var listContent: VariableListObject {
        .init(id: id!, key: key, value: value)
    }

    var getContent: VariableGetObject {
        .init(id: id!, key: key, name: name, value: value, notes: notes)
    }

    func create(_ input: VariableCreateObject) throws {
        key = input.key
        name = input.name
        value = input.value
        notes = input.notes
    }

    func update(_ input: VariableUpdateObject) throws {
        key = input.key
        name = input.name
        value = input.value ?? value
        notes = input.notes ?? notes
    }

    func patch(_ input: VariablePatchObject) throws {
        key = input.key ?? key
        name = input.name ?? name
        value = input.value ?? value
        notes = input.notes ?? notes
    }
}

// MARK: - api validation

extension VariableListObject: Content {}
extension VariableGetObject: Content {}
extension VariableCreateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension VariableUpdateObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250))
        validations.add("name", as: String.self, is: !.empty && .count(...250))
    }
}

extension VariablePatchObject: ValidatableContent {

    public static func validations(_ validations: inout Validations) {
        validations.add("key", as: String.self, is: !.empty && .count(...250), required: false)
        validations.add("name", as: String.self, is: !.empty && .count(...250), required: false)
    }
}
