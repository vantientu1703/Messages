//
//  MessageCellModel.swift
//  MessagesTests
//
//  Created by Văn Tiến Tú on 8/25/19.
//  Copyright © 2019 Văn Tiến Tú. All rights reserved.
//

import XCTest

class MessageCellModelTests: XCTestCase {

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
        let model1 = MessageCellModel(message1)
        XCTAssertEqual(message1.content, model1.content)
        
        let message2 = Message(nil)
        let model2 = MessageCellModel(message2)
        XCTAssertEqual(nil, model2.content)
        
        let message3 = Message("this is a message")
        let model3 = MessageCellModel(message3)
        XCTAssertEqual("this is a message", model3.content)
    }

}
