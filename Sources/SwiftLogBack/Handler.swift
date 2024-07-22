//
//  File.swift
//  
//
//  Created by Yang Jianqi on 2024/7/11.
//

import Foundation
import Logging

/// 控制台的日志输出Handler
public struct ConsoleLogHandler: LogHandler {

    // 控制台日志输出流
    private let stream: TextOutputStream & Sendable = ConsoleOutputStream()
    // 日志标签
    private var label: String = "console.Logger"
    // appender配置
    public var appender: Appender

    public var logLevel: Logger.Level = .info

    public var metadataProvider: Logger.MetadataProvider?

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(metadata)
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set(newValue) {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }

    public init(appender: Appender) {
        self.appender = appender as! ConsoleAppender
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
        var stream = self.stream
        let logMsg = formatMessage(appender: self.appender, label: label, level: level, message: message, metadata: prettyMetadata, source: source, file: file, function: function, line: line)
        stream.write("\(logMsg)")
    }

}

// 控制台输出流
struct ConsoleOutputStream: TextOutputStream {
    mutating func write(_ string: String) {
        print(string)
    }
}

/// 文件日志输出Handler
public struct FileLogHandler: LogHandler {

    // 文件日志输出流
    private let stream: TextOutputStream & Sendable
    // 日志标签
    private var label: String = "file.Logger"
    // appender配置
    public var appender: Appender

    public var logLevel: Logger.Level = .info

    public var metadataProvider: Logger.MetadataProvider?

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(metadata)
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set(newValue) {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }

    public init(appender: Appender, fileLogger: FileLogging) {
        self.appender = appender as! FileAppender
        self.stream = fileLogger.stream
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
        var stream = self.stream
        let logMsg = formatMessage(appender: self.appender, label: label, level: level, message: message, metadata: prettyMetadata, source: source, file: file, function: function, line: line)
        stream.write("\(logMsg)")
    }
}

public struct FileLogging {
    let stream: TextOutputStream
    private var localFile: URL
    private var appender: Appender

    public init(to localFile: URL, appender: Appender) throws {
        self.stream = try FileOutputStream(localFile: localFile)
        self.localFile = localFile
        self.appender = appender
    }

    public func handler(label: String) -> FileLogHandler {
        return FileLogHandler(appender: appender, fileLogger: self)
    }

    public static func logger(appender: Appender, label: String, localFile url: URL) throws -> Logger {
        let logging = try FileLogging(to: url, appender: appender)
        return Logger(label: label, factory: logging.handler)
    }
}

// 文件输出流
struct FileOutputStream: TextOutputStream {
    // 异常处理
    enum FileHandlerOutputStream: Error {
        case couldNotCreateFile // 文件创建失败
    }

    private let fileHandle: FileHandle
    let encoding: String.Encoding

    init(localFile url: URL, encoding: String.Encoding = .utf8) throws {
        do {
            try createLogDirectoryAndFileIfNeeded(at: url)
        } catch {
            throw FileHandlerOutputStream.couldNotCreateFile
        }

        let fileHandle = try FileHandle(forWritingTo: url)
        fileHandle.seekToEndOfFile()
        self.fileHandle = fileHandle
        self.encoding = encoding
    }

    mutating func write(_ string: String) {
        if let data = string.data(using: encoding) {
            fileHandle.write(data)
        }
    }
}

/// 日志滚动文件输出Handler
public struct RollingFileLogHandler: LogHandler {

    // 文件日志输出流
    private let stream: TextOutputStream & Sendable
    // 日志标签
    private var label: String = "rollingFile.Logger"
    // appender配置
    public var appender: Appender

    public var logLevel: Logger.Level = .info

    public var metadataProvider: Logger.MetadataProvider?

    private var prettyMetadata: String?
    public var metadata = Logger.Metadata() {
        didSet {
            self.prettyMetadata = self.prettify(metadata)
        }
    }

    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
        get {
            return self.metadata[metadataKey]
        }
        set(newValue) {
            self.metadata[metadataKey] = newValue
        }
    }

    private func prettify(_ metadata: Logger.Metadata) -> String? {
        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
    }

    public init(appender: Appender, fileLogger: RollingFileLogging) {
        self.appender = appender as! RollingFileAppender
        self.stream = fileLogger.stream
    }

    public func log(level: Logger.Level,
                    message: Logger.Message,
                    metadata: Logger.Metadata?,
                    source: String,
                    file: String,
                    function: String,
                    line: UInt) {
        let prettyMetadata = metadata?.isEmpty ?? true
            ? self.prettyMetadata
            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
        var stream = self.stream
        let logMsg = formatMessage(appender: self.appender, label: label, level: level, message: message, metadata: prettyMetadata, source: source, file: file, function: function, line: line)
        stream.write("\(logMsg)")
    }
}

public struct RollingFileLogging {
    let stream: TextOutputStream
    private var localFile: URL
    private var appender: Appender

    public init(to localFile: URL, appender: Appender) throws {
        self.stream = try FileOutputStream(localFile: localFile)
        self.localFile = localFile
        self.appender = appender
    }

    public func handler(label: String) -> RollingFileLogHandler {
        return RollingFileLogHandler(appender: appender, fileLogger: self)
    }

    public static func logger(appender: Appender, label: String, localFile url: URL) throws -> Logger {
        let logging = try FileLogging(to: url, appender: appender)
        return Logger(label: label, factory: logging.handler)
    }
}

// 滚动文件输出流
struct RollingFileOutputStream: TextOutputStream {
    // 异常处理
    enum FileHandlerOutputStream: Error {
        case couldNotCreateFile // 文件创建失败
    }

    private let fileHandle: FileHandle
    let encoding: String.Encoding

    init(localFile url: URL, encoding: String.Encoding = .utf8) throws {
        do {
            try createLogDirectoryAndFileIfNeeded(at: url)
        } catch {
            throw FileHandlerOutputStream.couldNotCreateFile
        }

        let fileHandle = try FileHandle(forWritingTo: url)
        fileHandle.seekToEndOfFile()
        self.fileHandle = fileHandle
        self.encoding = encoding
    }

    mutating func write(_ string: String) {
        if let data = string.data(using: encoding) {
            fileHandle.write(data)
        }
    }
}
