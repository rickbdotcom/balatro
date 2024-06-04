//
//  File.swift
//  
//
//  Created by Burgess, Rick (CHICO-C) on 6/4/24.
//

import Foundation

final class FileMonitor {
    let url: URL
    let fileHandle: FileHandle
    let source: DispatchSourceFileSystemObject
    let continuation: AsyncStream<DispatchSource.FileSystemEvent>.Continuation
    let events: AsyncStream<DispatchSource.FileSystemEvent>

    init(url: URL, eventMask: DispatchSource.FileSystemEvent = .extend) throws {
        let (events, continuation) = AsyncStream.makeStream(of: DispatchSource.FileSystemEvent.self)
        let fileHandle = try FileHandle(forReadingFrom: url)
        let source = DispatchSource.makeFileSystemObjectSource(
            fileDescriptor: fileHandle.fileDescriptor,
            eventMask: eventMask,
            queue: DispatchQueue.main
        )

        source.setEventHandler {
            continuation.yield(source.data)
        }
        
        source.setCancelHandler {
            try? fileHandle.close()
            continuation.finish()
        }

        fileHandle.seekToEndOfFile()
        source.resume()

        self.url = url
        self.fileHandle = fileHandle
        self.source = source
        self.continuation = continuation
        self.events = events
    }

    deinit {
        source.cancel()
    }
}

extension DispatchSource.FileSystemEvent {

    var description: String {
        var flags = [String]()
        if contains(.delete) {
            flags.append("delete")
        }
        if contains(.delete) {
            flags.append("delete")
        }
        if contains(.write) {
            flags.append("write")
        }
        if contains(.extend) {
            flags.append("extend")
        }
        if contains(.attrib) {
            flags.append("attrib")
        }
        if contains(.link) {
            flags.append("link")
        }
        if contains(.rename) {
            flags.append("rename")
        }
        if contains(.revoke) {
            flags.append("revoke")
        }
        if contains(.funlock) {
            flags.append("funlock")
        }
        return flags.joined(separator: "\n")
    }
}
