//
//  File.swift
//  
//
//  Created by Yang Jianqi on 2024/7/14.
//

import Foundation

// 定义日志级别的枚举
enum LogLevel: String, Codable {
    case info
    case debug
    case error
    case warn
    case fatal
}

/// protocols: Appender, ConsoleAppenderProtocol, FileAppenderProtocol, RollingFileAppenderProtocol
// Appender协议
public protocol Appender: Codable {
    var type: AppenderEnum { get }
    var logLevel: String { get }
    var format: String { get }
}

// ConsoleAppenderProtocol
public protocol ConsoleAppenderProtocol: Appender {
    var charset: String { get }
}

// FileAppenderProtocol
public protocol FileAppenderProtocol: Appender {
    var filePath: String { get }
    var charset: String { get }
}

// RollingFileAppenderProtocol
public protocol RollingFileAppenderProtocol: Appender {
    var filePath: String { get }
    var charset: String { get }
    var rollingPolicy: RollingPolicy { get }
}

// RollingPolicy滚动策略
public struct RollingPolicy: Codable {
    let type: RollingPolicyType
    let interval: String?
    let maxFileSize: String?
    let maxRetentionDays: Int?
}

// RollingPolicyType滚动策略类型
public enum RollingPolicyType: String, Codable {
    case timeBased = "timeBased"
    case sizeBased = "sizeBased"
    case timeAndSizeBased = "timeAndSizeBased"
}

extension RollingPolicyType {
    public init(from decoder: Decoder) throws {
        let container = try decoder.singleValueContainer()
        let rawValue = try container.decode(String.self)
        guard let rollingPolicy = RollingPolicyType(rawValue: rawValue) else {
            throw DecodingError.dataCorruptedError(in: container, debugDescription: "Invalid [rollingPolicyType] value[\(rawValue)]")
        }
        self = rollingPolicy
    }
}

/// Appenders: ConsoleAppender, FileAppender, RollingFileAppender
public enum AppenderEnum: String, Codable, CodingKey {
    case ConsoleAppender
    case FileAppender
    case RollingFileAppender
}

// 包装通用Appender
struct AnyAppender: Codable {
    var appender: Appender

    enum CodingKeys: String, CodingKey {
        case type
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let type = try container.decode(AppenderEnum.self, forKey: .type)

        switch type {
        case .ConsoleAppender:
            appender = try ConsoleAppender(from: decoder)
        case .FileAppender:
            appender = try FileAppender(from: decoder)
        case .RollingFileAppender:
            appender = try RollingFileAppender(from: decoder)
        }
    }

    func encode(to encoder: Encoder) throws {
        try appender.encode(to: encoder)
    }
}

// ConsoleAppender
struct ConsoleAppender: ConsoleAppenderProtocol {
    var type: AppenderEnum = .ConsoleAppender
    var format: String
    var charset: String
    var logLevel: String
}

// FileAppender
struct FileAppender: FileAppenderProtocol {
    var type: AppenderEnum = .FileAppender
    var format: String
    var charset: String
    var logLevel: String
    var filePath: String
}

// RollingFileAppender
struct RollingFileAppender: RollingFileAppenderProtocol {
    var type: AppenderEnum = .RollingFileAppender
    var format: String
    var charset: String
    var logLevel: String
    var filePath: String
    var rollingPolicy: RollingPolicy
}
