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

    func removeBackups(for profile: String?) throws {
        try FileManager.default.removeItemIfExists(at: backupDirectory(for: profile))
    }

    func restore(_ name: String, for profile: String?) throws {
        let url = URL(fileURLWithPath: name.jkr(), relativeTo: backupDirectory(for: profile))
        try FileManager.default.removeItemIfExists(at: saveGameURL(for: profile))
        try FileManager.default.copyItem(at: url, to: saveGameURL(for: profile))
    }

    func restore(_ index: Int, for profile: String?) throws {
        let urls = try FileManager.default.contentsOfDirectory(at: backupDirectory(for: profile), includingPropertiesForKeys: nil).sorted {
            $0.lastPathComponent.localizedStandardCompare($1.lastPathComponent) == .orderedAscending
        }
        guard index < urls.count && index >= 0 else {
            return
        }
        let url = urls[urls.count - 1 - index]
        try FileManager.default.removeItemIfExists(at: saveGameURL(for: profile))
        try FileManager.default.copyItem(at: url, to: saveGameURL(for: profile))
        print("Restored \(url.lastPathComponent)")
    }
}

extension FileManager {

    func removeItemIfExists(at url: URL) throws {
        if fileExists(atPath: url.path) {
            try removeItem(at: url)
        }
    }
}

extension String {

    func jkr() -> String {
        if hasSuffix(".jkr") {
            self
        } else {
            self + ".jkr"
        }
    }
}
