//
//  MessageCellModel.swift
//  Messages
//
//  Created by Văn Tiến Tú on 8/23/19.
//  Copyright © 2019 Văn Tiến Tú. All rights reserved.
//

import UIKit

class MessageCellModel {
    
    fileprivate var message: Message?
    
    init(_ message: Message? = nil) {
        self.message = message
    }
    
    var content: String? {
        return self.message?.content
    }
}
