//
//  File.swift
//  
//
//  Created by Burgess, Rick (CHICO-C) on 6/4/24.
//

import Foundation
import ArgumentParser

struct EditSave: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            commandName: "edit-save",
            abstract: "Edit Save Game"
        )
    }

    @Option(help: "profile")
    var profile: String?

    @Option(help: "dollars")
    var dollars: String?

    func run() throws {
        let profile = self.profile ?? "1"
        let url = FileSystem().saveGameURL(for: profile)
        var jkrDictionary = try Dictionary(contentsOfJKR: url)

        if let dollars,
           var game = jkrDictionary["GAME"] as? [AnyHashable: Any] {
            game["dollars"] = Int(dollars)
            jkrDictionary["GAME"] = game
        }

        let out = URL(fileURLWithPath: "/Users/2501156/Desktop/out.lua")
        try jkrDictionary.convertToLua().write(to: out, atomically: true, encoding: .utf8)
    }
}
