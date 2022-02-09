//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import Foundation

public struct EditorGenerator {
    
    let descriptor: ModelDescriptor
    let module: String
    
    public init(_ descriptor: ModelDescriptor, module: String) {
        self.descriptor = descriptor
        self.module = module
    }
    
    private func generateField(_ property: PropertyDescriptor) -> String {
        switch property.formFieldType {
        case .image:
            return generateImageField(property)
        default:
            return generateDefaultField(property)
        }
    }
 
    private func generateImageField(_ property: PropertyDescriptor) -> String {
        var res = """
            \(property.formFieldType.fieldName)(\"\(property.name)\", path: "\(module.lowercased())/\(descriptor.name.lowercased())")
        """
        res += """
            .read {
                    if let key = model.\(property.name) {
                        $1.output.context.previewUrl = $0.fs.resolve(key: key)
                    }
                    ($1 as! ImageField).imageKey = model.\(property.name)
            }
            .write { model.\(property.name) = ($1 as! ImageField).imageKey }
        """
        return res
    }
    
    private func generateDefaultField(_ property: PropertyDescriptor) -> String {
        var res = """
            \(property.formFieldType.fieldName)(\"\(property.name)\")
        """
        if property.isRequired {
            res += """
            
                .config {
                    $0.output.context.label.required = true
                }
                .validators {
                    FormFieldValidator.required($1)
                }
            """
        }
        res += """

            .read { $1.output.context.value = model.\(property.name) }
            .write { model.\(property.name) = $1.input }
        """
        return res
    }
    
    
    public func generate() -> String {

        let fields = descriptor.properties.map { generateField($0) }.joined(separator: "\n\n")

        return """
        struct \(module)\(descriptor.name)Editor: FeatherModelEditor {
            let model: \(module)\(descriptor.name)Model
            let form: AbstractForm

            init(model: \(module)\(descriptor.name)Model, form: AbstractForm) {
                self.model = model
                self.form = form
            }

                @FormFieldBuilder
                func createFields(_ req: Request) -> [FormField] {
                \(fields)
            }
        }
        """
    }
}
