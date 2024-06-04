//
//  File.swift
//  
//
//  Created by Burgess, Rick (CHICO-C) on 6/4/24.
//

import Foundation

class FileSystem {

    static func defaultURL() -> URL {
        let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first!
        return URL(fileURLWithPath: "Balatro", relativeTo: appSupportURL)
    }
    
    let baseURL: URL

    init(baseURL: URL = FileSystem.defaultURL()) {
        self.baseURL = baseURL
    }

    func profileDirectory(for profile: String?) -> URL {
        URL(fileURLWithPath: profile ?? "1", relativeTo: baseURL)
    }

    func saveGameURL(for profile: String?) -> URL {
        URL(fileURLWithPath: "save.jkr", relativeTo: profileDirectory(for: profile))
    }

    func metaURL(for profile: String?) -> URL {
        URL(fileURLWithPath: "meta.jkr", relativeTo: profileDirectory(for: profile))
    }
    
    func profileURL(for profile: String?) -> URL {
        URL(fileURLWithPath: "profile.jkr", relativeTo: profileDirectory(for: profile))
    }

    func settingsURL() -> URL {
        URL(fileURLWithPath: "settings.jkr", relativeTo: baseURL)
    }

    func backupDirectory(for profile: String?) -> URL {
        URL(fileURLWithPath: "bak", relativeTo: profileDirectory(for: profile))
    }

    func createBackupDirectory(for profile: String?) throws {
        try FileManager.default.createDirectory(at: backupDirectory(for: profile), withIntermediateDirectories: true)
    }
}
