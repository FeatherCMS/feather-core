//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2022. 01. 14..
//

import Foundation

public struct CopyGenerator {
    
    let formatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "y. MM. d."
        return formatter
    }()
    
    func getGitUser() -> String {
        let task = Process()
        task.launchPath = "/bin/bash/"
        task.arguments = ["-c", "git config user.name"]
        let pipe = Pipe()
        task.standardOutput = pipe
        task.launch()
        task.waitUntilExit()
        let data = pipe.fileHandleForReading.readDataToEndOfFile()
        guard let output = String(data: data, encoding: .utf8) else {
            return ""
        }
        return output.trimmingCharacters(in: .whitespacesAndNewlines)
    }

    public func generate() -> String {
        """
        
        """
    }
    
//    func copy(file: String, module: String, author: String, date: Date = .init()) -> String {
//        return """
//        //
//        //  \(file).swift
//        //  \(module)Module
//        //
//        //  Created by \(author) on \(formatter.string(from: date)).
//        //
//        
//        import FeatherCore
//        """
//    }
    
}
