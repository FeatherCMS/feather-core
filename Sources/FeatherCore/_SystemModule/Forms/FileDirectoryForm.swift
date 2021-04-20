//
//  File.swift
//  FileModule
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

//import FeatherCore
//
//final class FileDirectoryForm: Form {
//
//    var key = FormField<String>(key: "key")
//    var name = FormField<String>(key: "name").alphanumerics().length(max: 250)
//    var notification: String?
//    
//    var fields: [FormFieldRepresentable] {
//        [key, name]
//    }
//
//    init() {}
//
//    func save(req: Request) -> EventLoopFuture<Void> {
//        let directoryKey = String((key.value! + "/" + name.value!).safePath().dropFirst().dropLast())
//        return req.fs.createDirectory(key: directoryKey)
//    }
//}
