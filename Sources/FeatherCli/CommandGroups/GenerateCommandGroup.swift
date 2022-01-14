//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 13..
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
            GenerateModuleCommand.name: GenerateModuleCommand(),
        ]
    }
}
