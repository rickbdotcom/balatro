import ArgumentParser

@main
struct BalatroTool: ParsableCommand {

    static var configuration = CommandConfiguration(
        abstract: "A utility for editing Balatro files.",
        subcommands: [
            JKR2JSON.self,
            JKR2Lua.self,
            EditSave.self
        ]
    )
}
