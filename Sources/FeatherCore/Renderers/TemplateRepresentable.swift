//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 11. 20..
//

import Vapor
import SwiftHtml

public protocol TemplateRepresentable {
    var tag: Tag { get }
}
