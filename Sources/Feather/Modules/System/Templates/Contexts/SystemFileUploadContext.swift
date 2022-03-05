//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

public struct SystemFileUploadContext {

    public let maxUploadSize: String
    public let form: FormContext
    
    public init(maxUploadSize: String, form: FormContext) {
        self.maxUploadSize = maxUploadSize
        self.form = form
    }
}
