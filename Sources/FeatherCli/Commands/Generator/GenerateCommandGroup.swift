//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//

import Vapor

struct GenerateCommandGroup: CommandGroup {
    
    static var name = "generate"

    let help: String
    let commands: [String: AnyCommand]
    
    var defaultCommand: AnyCommand? {
        self.commands[HelloCommand.name]
    }

    init() {
        self.help = "Generate command group help"

        self.commands = [
            GenerateModelCommand.name: GenerateModelCommand(),
        ]
    }
}
