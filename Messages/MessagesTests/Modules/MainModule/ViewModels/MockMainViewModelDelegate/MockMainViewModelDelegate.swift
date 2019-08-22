//
//  MockMainViewModelDelegate.swift
//  MessagesTests
//
//  Created by Văn Tiến Tú on 8/25/19.
//  Copyright © 2019 Văn Tiến Tú. All rights reserved.
//

import Foundation
import XCTest

class MockMainViewModelDelegate: MainViewModelDelegate {
    
    var expectationdidSplitMessagesSuccess: XCTestExpectation?
    var expectationdidSplitMessageFail: (expectation: XCTestExpectation?, errorString: String?)?
    
    func didSplitMessagesSuccess() {
        self.expectationdidSplitMessagesSuccess?.fulfill()
    }
    
    func didSplitMessageFail(_ errorString: String?) {
        if let ex = self.expectationdidSplitMessageFail {
            if ex.errorString == errorString {
                ex.expectation?.fulfill()
            }
        }
    }
}
