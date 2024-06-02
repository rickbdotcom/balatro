//
//  SaveGame.swift
//  Balatro Helper
//
//  Created by Burgess, Rick (CHICO-C) on 5/4/24.
//

import Foundation
import Compression
import Foundation

extension Data {
    
    func decompress() -> Data? {
        let bufferSize = count * 10
        var outputBuffer = [UInt8](repeating: 0, count: bufferSize)
        
        let decompressedSize = withUnsafeBytes {
            compression_decode_buffer(&outputBuffer, outputBuffer.count, $0.baseAddress!.assumingMemoryBound(to: UInt8.self), count, nil, COMPRESSION_ZLIB)
        }
        
        return if decompressedSize > 0 {
            Data(bytes: outputBuffer, count: decompressedSize)
        } else {
            nil
        }
    }
}


/*
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
             if let appSupportURL = FileManager.default.urls(for: .applicationSupportDirectory, in: .userDomainMask).first {
                 let url = URL(fileURLWithPath: "Balatro/1/save.jkr", relativeTo: appSupportURL)
                 let inputData = try Data(contentsOf: url)
                 if let decompressedData = inputData.decompress(),
                    let code = String(data: decompressedData, encoding: .utf8) {
                     let L = LuaState(libraries: .all)
                     try L.dostring(code)
                     if let dict: [AnyHashable: Any] = L.tovalue(1) {
                         try JSONSerialization.data(withJSONObject: dict.convertToStringKeys(), options: .prettyPrinted).write(to: URL(fileURLWithPath: "/Users/2501156/Desktop/save.json"))
                     }
                     L.close()
                 }
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

 */
