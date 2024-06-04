//
//  SaveGame.swift
//  Balatro Helper
//
//  Created by Burgess, Rick (CHICO-C) on 5/4/24.
//

import Foundation
import Compression
import Lua

extension Dictionary where Key == AnyHashable, Value == Any {

    init(contentsOfJKR url: URL) throws {
        let inputData = try Data(contentsOf: url)
        guard let decompressedData = inputData.decompress(),
              let code = String(data: decompressedData, encoding: .utf8) else {
            self = [:]
            return
        }
        let L = LuaState(libraries: .all)
        try L.dostring(code)
        self = L.tovalue(1) ?? [:]
        L.close()
    }

    func convertToStringKeys() -> [String: Any] {
        Dictionary<String, Any>(uniqueKeysWithValues: map { key, value in
            if let value = value as? [AnyHashable: Any] {
                ("\(key)", value.convertToStringKeys())
            } else {
                ("\(key)", value)
            }
        })
    }

    func writeJkrJSON(to url: URL) throws {
        try JSONSerialization
            .data(withJSONObject: convertToStringKeys(), options: .prettyPrinted)
            .write(to: url)
    }
}

extension Data {
    
    func decompress() -> Data? {
        let bufferSize = count * 10
        var outputBuffer = [UInt8](repeating: 0, count: bufferSize)
        
        let decompressedSize = withUnsafeBytes {
            compression_decode_buffer(
                &outputBuffer,
                outputBuffer.count,
                $0.baseAddress!.assumingMemoryBound(to: UInt8.self),
                count,
                nil,
                COMPRESSION_ZLIB
            )
        }
        
        return if decompressedSize > 0 {
            Data(bytes: outputBuffer, count: decompressedSize)
        } else {
            nil
        }
    }
}
