//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public protocol FormFieldView: Encodable {
    var type: FormFieldType { get }

    var key: String { get }
    var required: Bool { get }
    var error: String? { get set }
}

