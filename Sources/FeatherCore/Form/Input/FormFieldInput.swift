//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public protocol FormFieldInput: AnyObject {
    func process(req: Request)
}

