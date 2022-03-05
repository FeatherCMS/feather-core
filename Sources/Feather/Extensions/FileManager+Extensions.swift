//
//  File.swift
//  
//
//  Created by Tibor Bodecs on 2021. 12. 23..
//

import Foundation

public extension FileManager {
    
    /// check if directory exists
    func isExistingDirectory(at path: String) -> Bool {
        var isDir: ObjCBool = false
        let exist = fileExists(atPath: path, isDirectory: &isDir)
        return exist && isDir.boolValue
    }

    /// check if file exists
    func isExistingFile(at path: String) -> Bool {
        var isDir: ObjCBool = false
        let exist = fileExists(atPath: path, isDirectory: &isDir)
        return exist && !isDir.boolValue
    }

    /// check if a directory exists and is empty
    func isEmptyDirectory(at path: String) -> Bool {
        do {
            guard isExistingDirectory(at: path) else {
                return false
            }
            return try contentsOfDirectory(atPath: path).isEmpty
        }
        catch {
            return false
        }
    }

    /// create directory with intermediate directories and posix permissions 0o744
    func createDirectory(at url: URL) throws {
        guard !isExistingDirectory(at: url.path) else {
            return
        }
        try createDirectory(at: url, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o744])
    }
    
    /// copy file if not exists
    func copy(at source: String, to destination: String) throws {
        guard fileExists(atPath: source), !fileExists(atPath: destination) else {
            return
        }
        try copyItem(atPath: source, toPath: destination)
    }

    /// copy file if not exists
    func copy(at source: URL, to destination: URL) throws {
        guard fileExists(atPath: source.path), !fileExists(atPath: destination.path) else {
            return
        }
        try copyItem(at: source, to: destination)
    }

    /// remove file if exists
    func removeFile(at url: URL) throws {
        guard fileExists(atPath: url.path) else {
            return
        }
        try removeItem(at: url)
    }
}

