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
