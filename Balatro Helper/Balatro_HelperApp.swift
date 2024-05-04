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
                let L = LuaState(libraries: .all)
                try L.dostring(code)
                if let dict: [AnyHashable: Any] = L.tovalue(1) {
                    try JSONSerialization.data(withJSONObject: dict.convertToStringKeys(), options: .prettyPrinted).write(to: URL(fileURLWithPath: "/Users/2501156/Downloads/save.json"))
                }
                L.close()
            }
        } catch {
            print(error)
        }
    }
}

extension Dictionary where Key == AnyHashable, Value == Any {
    func convertToStringKeys() -> [String: Any] {
        Dictionary<String, Any>(uniqueKeysWithValues: map { key, value in
            if let value = value as? [AnyHashable: Any] {
                ("\(key)", value.convertToStringKeys())
            } else {
                ("\(key)", value)
            }
        })
    }
}
