//
//  MessageTests.swift
//  MessagesTests
//
//  Created by Văn Tiến Tú on 8/25/19.
//  Copyright © 2019 Văn Tiến Tú. All rights reserved.
//

import XCTest

class MessageTests: XCTestCase {

    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testExample() {
        // This is an example of a functional test case.
        // Use XCTAssert and related functions to verify your tests produce the correct results.
    }

    func testPerformanceExample() {
        // This is an example of a performance test case.
        self.measure {
            // Put the code you want to measure the time of here.
        }
    }
    
    func test_init() {
        let message1 = Message(nil)
        XCTAssertEqual(message1.content, nil)
        
        let message2 = Message("this is a message")
        XCTAssertEqual("this is a message", message2.content)
    }
    
}
