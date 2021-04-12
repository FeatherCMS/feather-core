//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//



final class ApiObjectCommand: Command {
    
    static let name = "object"
        
    struct Signature: CommandSignature {

        @Argument(name: "name", help: "The name of the API object")
        var name: String
        
        @Argument(name: "fields", help: "List of fields (id:UUID,name:String)")
        var name: String
    }

    let help = "This command will generate CRUD objects for a given API model."

    func run(using context: CommandContext, signature: Signature) throws {
        let objectName = signature.name.capitalized

        context.console.info(objectName)
    }
}
