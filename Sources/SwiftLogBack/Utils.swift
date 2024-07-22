//
//  File.swift
//  
//
//  Created by Yang Jianqi on 2024/7/11.
//

import Foundation

// 创建文件
func createLogDirectoryAndFileIfNeeded(at url: URL) {
    // 获取文件的父目录
    let directoryURL = url.deletingLastPathComponent()
    // 判断文件夹是否存在
    if !FileManager.default.fileExists(atPath: directoryURL.path) {
        // 如果不存在则创建文件夹
        do {
            try FileManager.default.createDirectory(at: directoryURL, withIntermediateDirectories: true, attributes: nil)
        } catch {
            print("Failed to create log directory: \(error)")
        }
    }
    // 判断文件是否存在
    if !FileManager.default.fileExists(atPath: url.path) {
        FileManager.default.createFile(atPath: url.path, contents: nil, attributes: nil)
    }
}

// 创建枚举值用于日志输出的颜色控制
enum ANSIColor: String {

    case black
    case red
    case green
    case yellow
    case blue
    case magenta
    case cyan
    case white

    var color: String {
        switch self {
        case .black:
            "\u{001B}[0;30m"
        case .red:
            "\u{001B}[0;31m"
        case .green:
            "\u{001B}[0;32m"
        case .yellow:
            "\u{001B}[0;33m"
        case .blue:
            "\u{001B}[0;34m"
        case .magenta:
            "\u{001B}[0;35m"
        case .cyan:
            "\u{001B}[0;36m"
        case .white:
            "\u{001B}[0;37m"
        }
    }
}
