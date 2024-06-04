//
//  File.swift
//
//
//  Created by Burgess, Rick (CHICO-C) on 6/4/24.
//

import Foundation
import ArgumentParser

struct Backup: AsyncParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            commandName: "backup",
            abstract: "Backup save games"
        )
    }

    @Option(help: "Profile to backup")
    var profile: String?

    func run() async throws {
        let fs = FileSystem()
        try fs.createBackupDirectory(for: profile)

        let saveGameURL = fs.saveGameURL(for: profile)
        let backupDirectory = fs.backupDirectory(for: profile)

        let monitor = try FileMonitor(url: saveGameURL)
        for try await _ in monitor.events {
            try backup(saveGameURL, to: backupDirectory)
        }
    }

    func backup(_ url: URL, to directory: URL) throws {
        let fileName = String(Int(Date.timeIntervalSinceReferenceDate))
        let dstURL = URL(fileURLWithPath: fileName + ".jkr", relativeTo: directory)
        try FileManager.default.copyItem(at: url, to: dstURL)
    }
}
