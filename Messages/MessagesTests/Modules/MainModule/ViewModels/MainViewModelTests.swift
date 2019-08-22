//
//  MainViewModelTests.swift
//  MessagesTests
//
//  Created by Văn Tiến Tú on 8/25/19.
//  Copyright © 2019 Văn Tiến Tú. All rights reserved.
//

import XCTest


class MainViewModelTests: XCTestCase {
    
    fileprivate var mockMainViewModelDelegate: MockMainViewModelDelegate?
    
    fileprivate var validMessage1 = "This is a single message"
    fileprivate var validMessage2 = "I can't believe Tweeter now supports chunking my messages, so I don't have to do it myself."
    
    fileprivate var invalidMessage1 = ""
    fileprivate var invalidMessage2 = "hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    fileprivate var invalidMessage3 = "hhh hhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhhh"
    
    fileprivate var validArrayMessage: [String] = ["1/2 I can't believe Tweeter now supports chunking", "2/2 my messages, so I don't have to do it myself."]
    
    
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        self.mockMainViewModelDelegate = MockMainViewModelDelegate()
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
    
    func test_valid_delegate() {
        let viewModel = MainViewModel()
        viewModel.delegate = self.mockMainViewModelDelegate
        if let lhs = self.mockMainViewModelDelegate, let rhs = viewModel.delegate as? MockMainViewModelDelegate {
            XCTAssertTrue(lhs === rhs)
        }
    }
    
    func test_split_message_success() {
        let expectation = self.expectation(description: "expection didSplitMessagesSuccess() to be called")
        
        self.mockMainViewModelDelegate?.expectationdidSplitMessagesSuccess = expectation
        let viewModel = MainViewModel()
        viewModel.delegate = self.mockMainViewModelDelegate
        let _ = viewModel.splitMessage(self.validMessage1)
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_split_message_fail_non_whitespace_over_50_characters() {
        let expectation = self.expectation(description: "expection didSplitMessageFail() to be called")
        
        self.mockMainViewModelDelegate?.expectationdidSplitMessageFail = (expectation, "Error: The message contains a span of non-whitespace characters longer than 50 characters")
        let viewModel = MainViewModel()
        viewModel.delegate = self.mockMainViewModelDelegate
        let _ = viewModel.splitMessage(self.invalidMessage2)
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_split_message_fail_message_over_50_characters() {
        let expectation = self.expectation(description: "expection didSplitMessageFail() to be called")
        
        self.mockMainViewModelDelegate?.expectationdidSplitMessageFail = (expectation, "Error: The message longer 50 characters")
        let viewModel = MainViewModel()
        viewModel.delegate = self.mockMainViewModelDelegate
        let _ = viewModel.splitMessage(self.invalidMessage3)
        self.waitForExpectations(timeout: 1, handler: nil)
    }
    
    func test_invalid_message_is_empty() {
        let viewModel = MainViewModel()
        let messages = viewModel.splitMessage(self.invalidMessage1)
        
        XCTAssertEqual(messages, [])
    }
    
    func test_invalid_message_non_whitespace_over_50_characters() {
        let viewModel = MainViewModel()
        let messages = viewModel.splitMessage(self.invalidMessage2)
        
        XCTAssertEqual(messages, [])
    }
    
    func test_invalid_message_over_50_characters() {
        let viewModel = MainViewModel()
        let messages = viewModel.splitMessage(self.invalidMessage3)
        
        XCTAssertEqual(messages, [])
    }
    
    func test_valid_message1() {
        let viewModel = MainViewModel()
        let messages = viewModel.splitMessage(self.validMessage1)
        
        XCTAssertEqual(messages, ["1/1 This is a single message"])
    }
    
    func test_valid_message2() {
        let viewModel = MainViewModel()
        let messages = viewModel.splitMessage(self.validMessage2)
        
        XCTAssertEqual(messages, ["1/2 I can't believe Tweeter now supports chunking", "2/2 my messages, so I don't have to do it myself."])
    }
    
    func test_append_messages() {
        let viewModel = MainViewModel()
        viewModel.appendMessages(self.validArrayMessage)
        
        XCTAssertEqual(viewModel.numberOfRows(), self.validArrayMessage.count)
    }
    
    func test_get_message() {
        let viewModel = MainViewModel()
        viewModel.appendMessages(self.validArrayMessage)
        
        // valid index path
        let indexPath1 = IndexPath(row: 0, section: 0)
        let message1 = viewModel.message(at: indexPath1)
        XCTAssertNotNil(message1)
        
        // invalid index path
        let indexPath2 = IndexPath(row: 2, section: 0)
        let message2 = viewModel.message(at: indexPath2)
        XCTAssertNil(message2)
    }
    
    func test_config_model() {
        let viewModel = MainViewModel()
        viewModel.appendMessages(self.validArrayMessage)
        
        // valid index path
        let indexPath1 = IndexPath(row: 0, section: 0)
        let message1 = viewModel.message(at: indexPath1)
        let model1 = viewModel.configViewModel(at: indexPath1)
        XCTAssertEqual(message1?.content, model1.content)
        
        // invalid index path
        let indexPath2 = IndexPath(row: 2, section: 0)
        let model2 = viewModel.configViewModel(at: indexPath2)
        XCTAssertEqual(model2.content, nil)
    }
}
