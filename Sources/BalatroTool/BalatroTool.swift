import ArgumentParser

@main
struct BalatroTool: AsyncParsableCommand {

    static var configuration = CommandConfiguration(
        commandName: "balatro",
        abstract: "A utility for editing Balatro files.",
        subcommands: [
            JKR2JSON.self,
            JKR2Lua.self,
            EditSave.self,
            Backup.self
        ],
        defaultSubcommand: Backup.self
    )
}
