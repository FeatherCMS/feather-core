//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 02..
//

import Foundation
import SwiftHtml

public struct FormContext {
    public var id: String
    public var token: String
    public var action: FormAction
    public var error: String?
    public var submit: String?
    public var fields: [TemplateRepresentable]
}
