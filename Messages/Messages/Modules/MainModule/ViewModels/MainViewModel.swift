//
//  MainViewModel.swift
//  Messages
//
//  Created by Văn Tiến Tú on 8/23/19.
//  Copyright © 2019 Văn Tiến Tú. All rights reserved.
//

import UIKit

protocol MainViewModelDelegate: class {
    func didSplitMessagesSuccess()
    func didSplitMessageFail(_ errorString: String?)
}

class MainViewModel {
    
    weak var delegate: MainViewModelDelegate?
    
    fileprivate var messages: [Message] = []
    
    func numberOfRows() -> Int {
        return self.messages.count
    }
    
    func appendMessages(_ messages: [String]) {
        if messages.count > 0 {
            for m in messages {
                self.messages.append(Message(m))
            }
        }
    }
    
    func configViewModel(at indexPath: IndexPath) -> MessageCellModel {
        return MessageCellModel(self.message(at: indexPath))
    }
    
    func message(at indexPath: IndexPath) -> Message? {
        guard indexPath.row < self.messages.count else {
            return nil
        }
        return self.messages[indexPath.row]
    }
    
    func splitMessage(_ message: String) -> [String] {
        if message.count == 0 {
            self.delegate?.didSplitMessagesSuccess()
            return []
        }
        do {
            let arrs = try message.split(by: 50)
            self.delegate?.didSplitMessagesSuccess()
            return arrs
        } catch {
            self.delegate?.didSplitMessageFail((error as? CustomError)?.localizedDescription)
            return []
        }
    }
}

enum CustomError: Error {
    case error
    case over50
    
    var localizedDescription: String {
        switch self {
        case .error:
            return "Error: The message contains a span of non-whitespace characters longer than 50 characters"
        case .over50:
            return "Error: The message longer 50 characters"
        }
    }
}

extension String {
    fileprivate func split(by count: Int) throws -> [String] {
        let mainString = self.trim()
        var arrs: [String] = []
        
        /*
         I assume to divide the message into each 50 characters
         I will calculate the number of messages, it's called assumeIndexMessages
         */
        var assumeIndexMessages = self.assumeIndexMessages(stringLength: mainString.count, count: count)
        
        /*
         Calculate the total number of indicator characters base-on the assumeIndexMessages, it's called partIndicatorCount
         */
        var partIndicatorCount = self.partIndicatorCount(by: assumeIndexMessages)
        
        /*
         I calculate the number of messsages that proximity to the actual number of messages
         It's called expectIndexMessages, it always smaller than the actual number of messages
         */
        var expectIndexMessages = self.assumeIndexMessages(stringLength: mainString.count + partIndicatorCount, count: count)
        
        /*
         If the case, the number of characteds of expectIndexMessages greater than the numebr of characters of assumeIndexMessages then partIndicatorCount will be changed so expectIndexMessages is also changed
         So recalculate partIndicatorCount and expectIndexMessages
         */
        while String(expectIndexMessages).count > String(assumeIndexMessages).count {
            partIndicatorCount = self.partIndicatorCount(by: expectIndexMessages)
            assumeIndexMessages = expectIndexMessages
            expectIndexMessages = self.assumeIndexMessages(stringLength: mainString.count + partIndicatorCount, count: count)
        }
        // Separate message to array sub messages by " " character
        let subStrings = mainString.split(separator: " ")
        
        var isCompleted = false
        while isCompleted == false {
            var i = 0
            var indicator = 1
            var splitMessage = "\(indicator)/\(expectIndexMessages)"
            while i < subStrings.count {
                let subStr = subStrings[i]
                
                // If subStr's count greater than "count" then throw error
                if subStr.count > count {
                    throw(CustomError.error)
                }
                let expectCount = splitMessage.count + subStr.count + 1 // Number 1 is whitespace
                
                // If expectCount greater than "count" then stored splitMessage to arrs,indicator increase 1 and create new splitMessage with indicator
                if expectCount > count {
                    // append plit message to arrs
                    arrs.append(splitMessage)
                    // create new split message
                    indicator += 1
                    splitMessage = "\(indicator)/\(expectIndexMessages)"
                }
                splitMessage.append(" \(subStr)")
                // If splitMessage's count greater than "count" then throw error
                if splitMessage.count > count {
                    throw(CustomError.over50)
                }
                i += 1
            }
            // If splitMessage's count greater than "count" then thow error
            if splitMessage.count > count {
                throw(CustomError.over50)
            }
            // Append the last split message
            arrs.append(splitMessage)
            
            let countString = String(arrs.count)
            let expectIndexString = String(expectIndexMessages)
            /*
             If countString.count equal expectIndexString.count then arrs.count is the actual number of messages that we are looking for and end looping
             else arrs.count is the proximity number of messages, assign expectIndexMessages = arrs.count
             continue looping and recalculate
             */
            if countString.count == expectIndexString.count {
                isCompleted = true
                // If arrs.count different expectIndexMessages then replace countString for expectIndexString
                if arrs.count != expectIndexMessages {
                    for i in 0..<arrs.count {
                        var elements = arrs[i].split(separator: " ")
                        if let firstElement = elements.first, firstElement.contains(expectIndexString) {
                            let newFirstElement = firstElement.replacingOccurrences(of: expectIndexString, with: countString)
                            elements[0] = Substring(newFirstElement)
                            arrs[i] = elements.joined(separator: " ")
                        }
                    }
                }
            } else {
                expectIndexMessages = arrs.count
                arrs.removeAll()
            }
        }
        return arrs
    }
    
    private func assumeIndexMessages(stringLength: Int, count: Int) -> Int {
        var assumeIndexMessages = 0
        if self.count % count == 0 {
            assumeIndexMessages = stringLength / count
        } else {
            assumeIndexMessages = stringLength / count + 1
        }
        return assumeIndexMessages
    }
    
    private func partIndicatorCount(by assumeIndexMessages: Int) -> Int {
        var partIndicatorCount = 0
        for i in 0..<assumeIndexMessages {
            let indicator = "\((i + 1))/\(assumeIndexMessages)"
            if i == 0 {
                // in the case indicator for first sub message, it have to insert a whitespace so plus 1
                partIndicatorCount += (indicator.count + 1)
            } else {
                partIndicatorCount += indicator.count
            }
        }
        return partIndicatorCount
    }
    
    func trim() -> String {
        return self.trimmingCharacters(in: .whitespacesAndNewlines)
    }
}


