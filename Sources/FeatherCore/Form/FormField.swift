//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public protocol FormField: AnyObject, FormFieldRepresentable {
    
    associatedtype Input: FormFieldInput
    associatedtype Output: FormFieldView

    var input: Input { get set }
    var output: Output { get set }

    var validation: InputValidator { get set }
    
    func process(req: Request)
    func validate(req: Request) -> EventLoopFuture<Bool>
}

public extension FormField {
    
    var templateData: TemplateData {
        output.encodeToTemplateData()
    }
    
    func process(req: Request) {
        input.process(req: req)
    }
    
    func validate(req: Request) -> EventLoopFuture<Bool> {
        validation
            .validate(req)
            .map { [unowned self] items -> [ValidationError] in
                for item in items {
                    if item.key == output.key {
                        output.error = item.message
                    }
                }
                return items
            }
            .map { $0.isEmpty }
    }
}
