//
//  Balatro_HelperApp.swift
//  Balatro Helper
//
//  Created by Burgess, Rick (CHICO-C) on 4/28/24.
//

import SwiftUI
import Lua

@main
struct Balatro_HelperApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
    init() {
        do {
            let inputData = try Data(contentsOf: URL(fileURLWithPath: "/Users/2501156/Downloads/save.jkr"))
            if let decompressedData = inputData.decompress(),
               let code = String(data: decompressedData, encoding: .utf8) {
                print(code)
                let L = LuaState(libraries: .all)
                try L.dostring(code)
                print(L.type(1))
                L.close()
            }
        } catch {
            print(error)
        }
    }
}
