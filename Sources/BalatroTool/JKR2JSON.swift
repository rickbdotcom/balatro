//
//  File.swift
//  
//
//  Created by Burgess, Rick (CHICO-C) on 6/4/24.
//

import Foundation
import ArgumentParser

struct JKR2JSON: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            commandName: "jkr2json",
            abstract: "Convert JKR file to JSON"
        )
    }

    @Argument(help: "JKR file to convert")
    var input: String?

    @Option(help: "path to JSON file")
    var output: String

    func run() throws {
        let inputURL = input.flatMap { URL(fileURLWithPath: $0) } ?? defaultSaveFileURL()
        let outputURL = URL(fileURLWithPath: output)

        let jkrDictionary = try Dictionary(contentsOfJKR: inputURL)
        try jkrDictionary.writeJkrJSON(to: outputURL)
    }

    func defaultSaveFileURL() -> URL {
        FileSystem().saveGameURL()
    }
}
