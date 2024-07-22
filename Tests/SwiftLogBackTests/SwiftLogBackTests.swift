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
            
        } else {
            print("nil")
        }
    }
}
