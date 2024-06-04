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
        let fileSystem = FileSystem()

        try fileSystem.createBackupDirectory(for: profile)
        let saveGameURL = fileSystem.saveGameURL(for: profile)

        let monitor = try FileMonitor(url: saveGameURL)
        for try await _ in monitor.events {
            try backup()
        }
    }

    func backup() throws {
        let fileSystem = FileSystem()

        let saveGameURL = fileSystem.saveGameURL(for: profile)
        let backupDirectory = fileSystem.backupDirectory(for: profile)
        
        let jkrDict = try Dictionary(contentsOfJKR: saveGameURL)
        
        let game = jkrDict["GAME"] as? [AnyHashable: Any]

        let round_scores = game?["round_scores"] as? [AnyHashable: Any]
        let furthest_ante = round_scores?["furthest_ante"]  as? [AnyHashable: Any]
        let ante = furthest_ante?["amt"]  as? Int ?? 0

        let round = game?["round"]  as? Int ?? 0

        let dateString = String(Int(Date.timeIntervalSinceReferenceDate))
        let fileName = "\(dateString)_0\(ante)_0\(round).jkr"
        let dstURL = URL(fileURLWithPath: fileName, relativeTo: backupDirectory)
        try FileManager.default.copyItem(at: saveGameURL, to: dstURL)
    }
}
