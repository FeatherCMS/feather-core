//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//

struct GenerateModelCommand: Command {
    
    static let name = "model"
        
    struct Signature: CommandSignature {

//        @Argument(name: "name", help: "The name of the API object")
//        var name: String
//
//        @Argument(name: "fields", help: "List of fields (id:UUID,name:String)")
//        var fields: String
    }

    let help = "This command will generate CRUD objects for a given API model."

    func run(using context: CommandContext, signature: Signature) throws {
//        let objectName = signature.name.capitalized
//        context.console.info(objectName)

//        let modelName = context.console.ask("Model name?")
//
//        var addNext: Bool = false
//        
//        repeat {
//            let modelName = context.console.ask("Property name (field)?")
//
//            let type = context.console.choose("Select a type", from: ["String", "Int", "Bool"])
//
//            let req = context.console.choose("Is required?", from: ["Yes", "No"])
//            
//            // if string type
//            let search = context.console.choose("Searchable?", from: ["Yes", "No"])
//
//            let order = context.console.choose("Ordering is allowed?", from: ["Yes", "No"])
//            
//            console.info("....")
//            
//            let next = context.console.choose("Add another one?", from: ["Yes", "No"])
//            addNext = next == "Yes"
//        }
//        while ( addNext )
        
    }
}
