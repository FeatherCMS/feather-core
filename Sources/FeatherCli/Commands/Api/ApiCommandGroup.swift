//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 12. 21..
//

import Vapor

struct ApiCommandGroup: CommandGroup {
    
    static var name = "api"

    let help: String
    let commands: [String: AnyCommand]
    
    var defaultCommand: AnyCommand? {
        self.commands[HelloCommand.name]
    }

    init() {
        self.help = "Api command group help"

        self.commands = [
            ApiObjectCommand.name: ApiObjectCommand(),
        ]
    }
}
