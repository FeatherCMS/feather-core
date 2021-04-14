//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public protocol FormFieldRepresentable {

    func process(req: Request)
    func validate(req: Request) -> EventLoopFuture<Bool>
    
    var templateData: TemplateData { get }
}

