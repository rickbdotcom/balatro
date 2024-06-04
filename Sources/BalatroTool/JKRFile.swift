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
        guard let code = try String(contentsOfJKR: url) else {
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

    func convertToLua() -> String {
        "return \(luaRepresentation())"
    }

    func luaRepresentation() -> String {
        let keyValues = map { key, value -> String in
            let keyString = if let key = key as? String {
                "[\"\(key)\"]"
            } else {
                "[\(key)]"
            }
            let valueString = if let value = value as? [AnyHashable: Any] {
                value.luaRepresentation()
            } else {
                "\"\(value)\""
            }
            return [keyString, valueString].joined(separator: "=")
        }
        return "{" + keyValues.joined(separator: ",") + "}"
    }
}

extension Dictionary where Key == String, Value == Any {

    func convertToIntKeys() -> [AnyHashable: Any] {
        Dictionary<AnyHashable, Any>(uniqueKeysWithValues: map { key, value in
            var luaKey: AnyHashable = key
            if let intKey = Int(key) {
                luaKey = intKey
            }
            return if let value = value as? [String: Any] {
                (luaKey, value.convertToIntKeys())
            } else {
                (luaKey, value)
            }
        })
    }
}


extension String {

    init?(contentsOfJKR url: URL) throws {
        guard let decompressedData = try Data(contentsOfJKR: url),
              let string = String(data: decompressedData, encoding: .utf8) else {
            return nil
        }
        self = string
    }
}

extension Data {

    init?(contentsOfJKR url: URL) throws {
        let inputData = try Data(contentsOf: url)
        guard let decompressedData = inputData.decompress() else {
            return nil
        }
        self = decompressedData
    }

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
