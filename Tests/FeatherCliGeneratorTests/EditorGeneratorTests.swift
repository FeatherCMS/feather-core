//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import XCTest
@testable import FeatherCliGenerator

final class EditorGeneratorTests: XCTestCase {

    func testGenerator() async throws {
        let descriptor = ModelDescriptor(name: "Account", properties: [
            .init(name: "email", databaseType: .string, formFieldType: .input, isRequired: false, isSearchable: true, isOrderingAllowed: true),
            .init(name: "password", databaseType: .string, formFieldType: .input, isRequired: true, isSearchable: true, isOrderingAllowed: true),
        ])
        
        let result = EditorGenerator(descriptor, module: "User").generate()
        let expectation = """
            struct UserAccountEditor: FeatherModelEditor {
                let model: UserAccountModel
                let form: AbstractForm

                init(model: UserAccountModel, form: AbstractForm) {
                    self.model = model
                    self.form = form
                }

                    @FormFieldBuilder
                    func createFields(_ req: Request) -> [FormField] {
                        InputField("email")
                .read { $1.output.context.value = model.email }
                .write { model.email = $1.input }

                InputField("password")
                .config {
                    $0.output.context.label.required = true
                }
                .validators {
                    FormFieldValidator.required($1)
                }
                .read { $1.output.context.value = model.password }
                .write { model.password = $1.input }
                }
            }
            """

        XCTAssertEqual(expectation, result)
    }
}
