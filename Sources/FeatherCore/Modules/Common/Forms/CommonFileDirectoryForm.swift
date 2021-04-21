//
//  File.swift
//  FileModule
//
//  Created by Tibor Bodecs on 2020. 06. 03..
//

final class CommonFileDirectoryForm: Form {

    var name: String?

    init() {
        super.init()
        fields = createFormFields()
    }

    private func createFormFields() -> [FormComponent] {
        [
            TextField(key: "name").read { [unowned self] req, field in self.name = field.input }
        ]
    }
    
//    func save(req: Request) -> EventLoopFuture<Void> {
//        let directoryKey = String((key.value! + "/" + name.value!).safePath().dropFirst().dropLast())
//        return req.fs.createDirectory(key: directoryKey)
//    }
}
