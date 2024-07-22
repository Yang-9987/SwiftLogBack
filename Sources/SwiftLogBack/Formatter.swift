//
//  File.swift
//  
//
//  Created by Yang Jianqi on 2024/7/11.
//

import Foundation
import Logging

enum LogParam: String {

    case date = "%date"
    case level = "%level"
    case label = "%label"
    case metadata = "%metadata"
    case traceId = "%traceId"
    case method = "%method"
    case fileLine = "%fileLine"
    case message = "%message"
    case newLine = "%n"

}

public func formatMessage(appender: Appender, label: String, level: Logger.Level, message: Logger.Message, metadata: String?, source: String, file: String, function: String, line: UInt) -> String {
    let formatList: [LogParam]
    formatList = appender.format.split(separator: " ").map { LogParam(rawValue: String($0))! }
    var msg = ""
    for format in formatList {
        switch format {
        case .date:
            // 添加日志时间
            msg += "\(timestampStr())" + " "
        case .level:
            // 添加日志级别
            msg += "[\(level)]" + " "
        case .label:
            // 添加日志标签
            msg += "[\(label)]" + " "
        case .metadata:
            // 添加日志元数据
            msg += "\(metadata ?? "")" + " "
        case .traceId:
            // MARK: 待修改 添加traceId
            msg += "[\(UUID().uuidString)]" + " "
        case .method:
            // 添加方法
            msg += "(\(source))" + " "
        case .fileLine:
            // 添加文件名和行号
            msg += "(\(file):\(line))" + " "
        case .message:
            // 添加日志消息
            msg += "\(message)" + " "
        case .newLine:
            // 添加换行符
            msg += "\n"
        }
    }
    return msg
}

public func timestampStr() -> String {
   // 返回当前时间，格式为"YYYY-MM-dd HH:mm:ss"
    let formatter = DateFormatter()
    formatter.dateFormat = "YYYY-MM-dd HH:mm:ss"
    return formatter.string(from: Date())
}
