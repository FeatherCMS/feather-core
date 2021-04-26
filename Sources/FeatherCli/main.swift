//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2020. 08. 29..
//

@_exported import Vapor

let console: Console = Terminal()
var input = CommandInput(arguments: CommandLine.arguments)
var context = CommandContext(console: console, input: input)

var commands = Commands(enableAutocomplete: true)

commands.use(GenerateCommandGroup(), as: GenerateCommandGroup.name)

//commands.use(HelloCommand(), as: HelloCommand.name, isDefault: false)

do {
    let group = commands.group(help: "Feather CMS cli tools - v1.0.0")
    try console.run(group, input: input)
}
catch {
    console.error("\(error)")
    exit(1)
}
