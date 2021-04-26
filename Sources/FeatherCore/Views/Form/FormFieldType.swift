//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 04. 14..
//

public enum FormFieldType: String, Encodable {

    case hidden
    
    case text
    case textarea
    
    case selection
    case multiselection
    
    case toggle
    case checkbox
    case radio
    case multigroupoption
    
    case file
    case multifile
    case image
    
    case submit
}
