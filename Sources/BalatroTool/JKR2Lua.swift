//
//  File.swift
//
//
//  Created by Burgess, Rick (CHICO-C) on 6/4/24.
//

import Foundation
import ArgumentParser

struct JKR2Lua: ParsableCommand {
    static var configuration: CommandConfiguration {
        .init(
            commandName: "jkr2lua",
            abstract: "Convert JKR file to Lua"
        )
    }

    @Argument(help: "JKR file to convert")
    var input: String?

    @Option(help: "path to Lua output file")
    var output: String

    func run() throws {
        let inputURL = input.flatMap { URL(fileURLWithPath: $0) } ?? defaultSaveFileURL()
        let outputURL = URL(fileURLWithPath: output)

        let data = try Data(contentsOfJKR: inputURL)
        try data?.write(to: outputURL)
    }

    func defaultSaveFileURL() -> URL {
        FileSystem().saveGameURL()
    }
}
