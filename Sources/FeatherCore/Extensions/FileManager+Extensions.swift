//
//  FileManager+Extensions.swift
//  FeatherCore
//
//  Created by Tibor Bodecs on 2020. 12. 17..
//

import Foundation

public extension FileManager {
    
    /// check if directory exists
    func directoryExists(at path: String) -> Bool {
        var isDir: ObjCBool = false
        let exist = fileExists(atPath: path, isDirectory: &isDir)
        return exist && isDir.boolValue
    }

    /// check if file exists
    func fileExists(at path: String) -> Bool {
        var isDir: ObjCBool = false
        let exist = fileExists(atPath: path, isDirectory: &isDir)
        return exist && !isDir.boolValue
    }

    /// check if a directory exists and is empty
    func isEmptyDirectory(at path: String) -> Bool {
        do {
            guard directoryExists(at: path) else {
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
        guard !directoryExists(at: url.path) else {
            return
        }
        try createDirectory(at: url, withIntermediateDirectories: true, attributes: [.posixPermissions: 0o744])
    }
    
    /// copy file if not exists
    func copy(at source: String, to destination: String) throws {
        guard !fileExists(atPath: source) else {
            return
        }
        try copyItem(atPath: source, toPath: destination)
    }

    /// copy file if not exists
    func copy(at source: URL, to destination: URL) throws {
        guard !fileExists(atPath: source.path) else {
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

