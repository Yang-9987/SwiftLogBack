// The Swift Programming Language
// https://docs.swift.org/swift-book

import Foundation
import Logging
import SwiftyJSON

/// 日志框架配置类
struct LogConfig: Codable {
    let logLevel: LogLevel
    let appenders: [AnyAppender]

    enum CodingKeys: String, CodingKey {
        case logLevel
        case appenders
    }
}

/// 解析json配置文件函数
func parseLogConfig(jsonData: Data) -> LogConfig? {
    let decoder = JSONDecoder()
    do {
        let config = try decoder.decode(LogConfig.self, from: jsonData)
        return config
    } catch {
        print("解析JSON时出错: \(error)")
        return nil
    }
}

/// 加载配置文件函数
/// 成功：返回LogConfig对象
/// 失败：返回nil
func loadConfig(configUrl: URL) -> LogConfig? {
    do {
        let data = try Data(contentsOf: configUrl)
        if let config = parseLogConfig(jsonData: data) {
            print("加载配置文件: " + "\(config)")
            return config
        } else {
            print("加载失败, 转换配置文件数据结构失败。")
            return nil
        }
    } catch {
        print("读取文件时出错: \(error)")
        return nil
    }
}

func configToLoggingSystem(config: LogConfig) throws {
    let logger = Logger(label: "configToLogging")
    var handlers:[LogHandler] = []
    config.appenders.forEach { appender in
        switch appender.appender.type {
        case .ConsoleAppender:
            let consoleAppender = appender.appender as! ConsoleAppender
            handlers.append(ConsoleLogHandler(appender: consoleAppender))
        case .FileAppender:
            let fileAppender = appender.appender as! FileAppender
            var path = fileAppender.filePath
            if(path.starts(with: "/")){
                logger.info("configPath: \(path)")
            } else {
                // 获取当前工作目录
                let currentPath = FileManager.default.currentDirectoryPath
                path = currentPath + "/" + path
                logger.info("configPath: \(path)")
            }
            let fileURL = URL(fileURLWithPath: path)
            let fileLogging = try? FileLogging(to: fileURL, appender: fileAppender)
            if let fileLogging = fileLogging {
                handlers.append(fileLogging.handler(label: "fileLogger"))
            } else {
                logger.error("Failed to load fileAppender")
            }
        case .RollingFileAppender:
            let rollingFileAppender = appender.appender as! RollingFileAppender
            var path = rollingFileAppender.filePath
            if(path.starts(with: "/")){
                logger.info("configPath: \(path)")
            } else {
                // 获取当前工作目录
                let currentPath = FileManager.default.currentDirectoryPath
                path = currentPath + "/" + path
                logger.info("configPath: \(path)")
            }
            let fileURL = URL(fileURLWithPath: path)
            let rollingFileLogging = try? RollingFileLogging(to: fileURL, appender: rollingFileAppender)
            if let rollingFileLogging = rollingFileLogging {
                handlers.append(rollingFileLogging.handler(label: "rollingFileLogger"))
            } else {
                logger.error("Failed to load rollingFileAppender")
            }
        }
    }
    LoggingSystem.bootstrap{ _ in
        return MultiplexLogHandler(handlers)
    }
}
