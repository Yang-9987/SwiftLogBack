////
////  File.swift
////  
////
////  Created by Yang Jianqi on 2024/7/11.
////
//
//import Foundation
//import Logging
//
//struct FileLogHandler: LogHandler {
//
//    let stream: TextOutputStream & Sendable
//    var label: String = "com.Logger"
//
//    private let fileURL: URL
//    private let rollingPolicy: LogConfiguration.AppenderConfiguration.RollingPolicy?
//    private let format: String?
//    private let charset: String?
//
//    public var logLevel: Logger.Level = .info
//
//    public var metadataProvider: Logger.MetadataProvider?
//
//    private var prettyMetadata: String?
//
//    init(stream: TextOutputStream & Sendable, label: String, fileURL: URL, rollingPolicy: LogConfiguration.AppenderConfiguration.RollingPolicy?, format: String, charset: String) {
//        self.stream = stream
//        self.label = label
//        self.fileURL = fileURL
//        self.rollingPolicy = rollingPolicy
//        self.format = format
//        self.charset = charset
//    }
//
//    public var metadata = Logger.Metadata() {
//        didSet {
//            self.prettyMetadata = self.prettify(metadata)
//        }
//    }
//
//    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
//        get {
//            return self.metadata[metadataKey]
//        }
//        set(newValue) {
//            self.metadata[metadataKey] = newValue
//        }
//    }
//
//    private func prettify(_ metadata: Logger.Metadata) -> String? {
//        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
//    }
//
//    public func log(level: Logger.Level,
//                    message: Logger.Message,
//                    metadata: Logger.Metadata?,
//                    source: String,
//                    file: String,
//                    function: String,
//                    line: UInt) {
//        let prettyMetadata = metadata?.isEmpty ?? true
//            ? self.prettyMetadata
//            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
//        let requestId = self.metadata["requestId"] ?? "nil"
//    }
//
//}
//
//// 定义控制台的日志输出Handler
//public struct ConsoleLogHandler: LogHandler {
//
//    private let stream: TextOutputStream & Sendable = ConsoleOutputStream()
//    private var label: String = "com.Logger"
//
//    public var logLevel: Logger.Level = .info
//
//    public var metadataProvider: Logger.MetadataProvider?
//
//    private var prettyMetadata: String?
//    public var metadata = Logger.Metadata() {
//        didSet {
//            self.prettyMetadata = self.prettify(metadata)
//        }
//    }
//
//    public subscript(metadataKey metadataKey: String) -> Logger.Metadata.Value? {
//        get {
//            return self.metadata[metadataKey]
//        }
//        set(newValue) {
//            self.metadata[metadataKey] = newValue
//        }
//    }
//
//    private func prettify(_ metadata: Logger.Metadata) -> String? {
//        return !metadata.isEmpty ? metadata.map { "\($0)=\($1)" }.joined(separator: " ") : nil
//    }
//
//    public func log(level: Logger.Level,
//                    message: Logger.Message,
//                    metadata: Logger.Metadata?,
//                    source: String,
//                    file: String,
//                    function: String,
//                    line: UInt) {
//        let prettyMetadata = metadata?.isEmpty ?? true
//            ? self.prettyMetadata
//            : self.prettify(self.metadata.merging(metadata!, uniquingKeysWith: { _, new in new }))
//
//        // 配置颜色，让日志更容易阅读
//        let levelColor: String
//        switch level {
//        case .trace:
//            levelColor = ANSIColor.white.color // White
//        case .debug:
//            levelColor = ANSIColor.cyan.color // Cyan
//        case .info:
//            levelColor = ANSIColor.green.color // Green
//        case .notice:
//            levelColor = ANSIColor.blue.color // Blue
//        case .warning:
//            levelColor = ANSIColor.yellow.color // Yellow
//        case .error:
//            levelColor = ANSIColor.red.color // Red
//        case .critical:
//            levelColor = ANSIColor.magenta.color // Magenta
//        }
//        var stream = self.stream
//        // stream.write("\(LogColor.white.color)\(self.timestamp()) \(levelColor)[\(level)] \(LogColor.green.color)[\(label)]: \(LogColor.green.color)\(prettyMetadata.map { "\($0)" } ?? "") \(LogColor.cyan.color)(\(file):\(line)\n\(LogColor.white.color)\(message)")
//        stream.write("\(self.timestamp()) [\(level)] [\(label)]: \(prettyMetadata.map { "\($0)" } ?? "") (\(file):\(line))\n\(message)\n")
//    }
//
//    private func timestamp() -> String {
//       // 返回当前时间，格式为"YYYY-MM-dd HH:mm:ss"
//        let formatter = DateFormatter()
//        formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
//        return formatter.string(from: Date())
//    }
//
//}
//
//struct ConsoleOutputStream: TextOutputStream {
//    mutating func write(_ string: String) {
//        print(string)
//    }
//}
