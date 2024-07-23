import XCTest
@testable import SwiftLogBack
@testable import Logging

final class SwiftLogBackTests: XCTestCase {
    func testExample() throws {
        // XCTest Documentation
        // https://developer.apple.com/documentation/xctest

        // Defining Test Cases and Test Methods
        // https://developer.apple.com/documentation/xctest/defining_test_cases_and_test_methods

        // Writing Test Methods
        let url = "/Users/yangjianqi/Documents/iOS_project/SwiftLogBack/logConfig.json"
        let fileURL = URL(fileURLWithPath: url)
        if let config = loadConfig(configUrl: fileURL) {
            print("success")
            config.appenders.forEach { appender in
                print(appender)
            }
        } else {
            print("nil")
        }
    }

    func testConsoleAppender() throws {
        // Writing Test Methods
        let url = "/Users/yangjianqi/Documents/iOS_project/SwiftLogBack/logConfig.json"
        let fileURL = URL(fileURLWithPath: url)
        if let config = loadConfig(configUrl: fileURL) {
            print("success")
            var handlers:[LogHandler] = []
            config.appenders.forEach { appender in
                switch appender.appender.type {
                case .ConsoleAppender:
                    handlers.append(ConsoleLogHandler(appender: appender.appender))
                case .FileAppender:
                    print("FileAppender")
                case .RollingFileAppender:
                    print("RollingFileAppender")
                }
            }
            LoggingSystem.bootstrap{ _ in
                return MultiplexLogHandler(handlers)
            }
            let logger = Logger(label: "com.example.test")
            logger.info("Hello, world!")
        } else {
            print("nil")
        }
    }

    func testFileAppender() throws {
        // Writing Test Methods
        let url = "/Users/yangjianqi/Documents/iOS_project/SwiftLogBack/logConfig.json"
        let fileURL = URL(fileURLWithPath: url)
        if let config = loadConfig(configUrl: fileURL) {
            print("success")
            var handlers:[LogHandler] = []
            config.appenders.forEach { appender in
                switch appender.appender.type {
                case .ConsoleAppender:
                    print("ConsoleAppender")
                case .FileAppender:
                    do {
                        let fileAppender = appender.appender as! FileAppender
                        var path = fileAppender.filePath
                        if(path.starts(with: "/")){
                            print("path1: \(path)")
                        } else {
                            let fileManager = FileManager.default
                            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                            path = documentDirectory.appendingPathComponent(path).path
                            // 获取当前工作目录
//                            let currentPath = FileManager.default.currentDirectoryPath
//                            path = currentPath + "/" + path
                            print("path2: \(path)")
                        }
                        let fileURL = URL(fileURLWithPath: path)
                        let fileLogging = try FileLogging(to: fileURL, appender: fileAppender)
                        handlers.append(FileLogHandler(appender: fileAppender, fileLogger: fileLogging))
                        print("FileAppender")
                    } catch {
                        print("Failed to load file appender: \(error)")
                    }
                case .RollingFileAppender:
                    print("RollingFileAppender")
                }
            }
            LoggingSystem.bootstrap{ _ in
                return MultiplexLogHandler(handlers)
            }
            let logger = Logger(label: "com.example.test")
            logger.info("Hello, world!")
        } else {
            print("nil")
        }
    }

    func testRollingFileAppender() throws {
        // Writing Test Methods
        let url = "/Users/yangjianqi/Documents/iOS_project/SwiftLogBack/logConfig.json"
        let fileURL = URL(fileURLWithPath: url)
        if let config = loadConfig(configUrl: fileURL) {
            print("success")
            var handlers:[LogHandler] = []
            config.appenders.forEach { appender in
                switch appender.appender.type {
                case .ConsoleAppender:
                    print("ConsoleAppender")
                case .FileAppender:
                    print("FileAppender")
                case .RollingFileAppender:
                    do {
                        let fileAppender = appender.appender as! RollingFileAppender
                        var path = fileAppender.filePath
                        if(path.starts(with: "/")){
                            print("path1: \(path)")
                        } else {
                            let fileManager = FileManager.default
                            let documentDirectory = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first!
                            path = documentDirectory.appendingPathComponent(path).path
                            // 获取当前工作目录
//                            let currentPath = FileManager.default.currentDirectoryPath
//                            path = currentPath + "/" + path
                            print("path2: \(path)")
                        }
                        let fileURL = URL(fileURLWithPath: path)
                        let fileLogging = try FileLogging(to: fileURL, appender: fileAppender)
                        handlers.append(FileLogHandler(appender: fileAppender, fileLogger: fileLogging))
                        print("FileAppender")
                    } catch {
                        print("Failed to load file appender: \(error)")
                    }
                }
            }
            LoggingSystem.bootstrap{ _ in
                return MultiplexLogHandler(handlers)
            }
            let logger = Logger(label: "com.example.test")
            logger.info("Hello, world!")
        } else {
            print("nil")
        }
    }

    func testAutoConfig() {
        // Writing Test Methods
        let url = "/Users/yangjianqi/Documents/iOS_project/SwiftLogBack/logConfig.json"
        let fileURL = URL(fileURLWithPath: url)
        do {
            if let config = loadConfig(configUrl: fileURL) {
                try configToLoggingSystem(config: config)
            } else {
                print("nil")
            }
        } catch {
            print("Failed to load file appender: \(error)")
        }
        let logger = Logger(label: "com.example.test")
        logger.info("Hello, world!")
    }
}
