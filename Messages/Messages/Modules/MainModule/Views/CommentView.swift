//
//  CommentView.swift
//  Messages
//
//  Created by Văn Tiến Tú on 8/19/19.
//  Copyright © 2019 Văn Tiến Tú. All rights reserved.
//

import UIKit

protocol CommentViewDelegate: class {
    func didChangeHeight(_ height: CGFloat)
    func sendMessage(_ message: String)
    func keyboardWillShow(constant: CGFloat)
    func keyboardWillHide(constant: CGFloat)
}

class CommentView: UIView {
    
    @IBOutlet weak var commentTextField: TextViewMaster!
    @IBOutlet weak var sendButton: UIButton!
    @IBOutlet weak var containView: UIView!
    
    weak var delegate: CommentViewDelegate?
    
    var isShow = false
    var isSend = false
    var isSendSuccess = false
    var keyboardVisibleHeight: CGFloat = 0
    
    fileprivate var oringinPoint = CGPoint.zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.addNotifications()
        self.configView()
    }
    
    private func configView() {
        self.enableSendButton(false)
        self.containView.setRaidus(20)
        self.commentTextField.delegate = self
        self.commentTextField.maxHeight = 300
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.isSend = true
        let message = self.commentTextField.text
        if let message = message {
            self.delegate?.sendMessage(message)
        }
    }
    
    fileprivate func enableSendButton(_ flag: Bool) {
        self.sendButton.isEnabled = flag
    }
    
    func splitMessageSuccess(_ flag: Bool) {
        self.isSendSuccess = flag
        if flag {
            self.enableSendButton(false)
            self.clearCommentTextField()
            if self.isShow {
                self.frame.size.height = Constant.commentViewHeight
                self.frame.origin = self.oringinPoint
            } else {
                self.frame.size.height = Constant.commentViewHeight
                self.frame.origin.y = UIScreen.main.bounds.height - Constant.commentViewHeight
            }
            self.layoutIfNeeded()
        } else {
            self.enableSendButton(true)
        }
    }
    
    func clearCommentTextField() {
        self.commentTextField.text = ""
    }
    
    deinit {
        self.removeNotifications()
    }
}

extension CommentView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        if textView.text.count > 0 {
            self.enableSendButton(true)
        } else {
            self.enableSendButton(false)
        }
        self.isSend = false
        self.calculateTextViewHeight()
    }
    
    fileprivate func calculateTextViewHeight() {
        guard let font = self.commentTextField.font else { return }
        if self.oringinPoint == .zero {
            self.oringinPoint = self.frame.origin
        }
        let constant: CGFloat = Constant.commentViewHeight / 2
        var textHeight = self.commentTextField.sizeThatFits(CGSize(width: self.commentTextField.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
        let numberOfLines = textHeight / font.lineHeight
        if numberOfLines < 2 {
            textHeight = constant
        }
        var heightChanged = constant + textHeight
        if heightChanged >= self.commentTextField.maxHeight {
            heightChanged = self.commentTextField.maxHeight
        }
        self.frame.origin.y = (self.oringinPoint.y - (heightChanged - constant * 2))
        self.frame.size.height = heightChanged
        self.layoutIfNeeded()
        self.delegate?.didChangeHeight(heightChanged)
    }
}

extension CommentView: TextViewMasterDelegate {
    func growingTextView(growingTextView: TextViewMaster, willChangeHeight height: CGFloat) {
        self.layoutIfNeeded()
    }
}

extension CommentView {
    fileprivate func addNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillShowNotification), name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(self.keyboardWillHideNotification), name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    fileprivate func removeNotifications() {
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillShowNotification, object: nil)
        NotificationCenter.default.removeObserver(self, name: UIResponder.keyboardWillHideNotification, object: nil)
    }
    
    @objc func keyboardWillShowNotification(_ notification: Notification) {
        if let userInfo = notification.userInfo {
            if let frameValue = userInfo[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
                let frame = frameValue.cgRectValue
                self.keyboardVisibleHeight = frame.height
                if self.isShow == false {
                    self.isShow = true
                    self.frame.origin.y = UIScreen.main.bounds.height - self.keyboardVisibleHeight - self.frame.height
                }
                self.delegate?.keyboardWillShow(constant: self.keyboardVisibleHeight + self.frame.height)
            }
            switch (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber) {
            case let (.some(duration), .some(curve)):
                let options = UIView.AnimationOptions(rawValue: curve.uintValue)
                UIView.animate(
                    withDuration: TimeInterval(duration.doubleValue),
                    delay: 0,
                    options: options,
                    animations: {
                        UIApplication.shared.keyWindow?.layoutIfNeeded()
                        return
                }, completion: { finished in
                    //TODO
                })
            default:
                break
            }
        }
        
    }
    
    @objc func keyboardWillHideNotification(_ notification: NSNotification) {
        self.keyboardVisibleHeight = 0
        var constant: CGFloat = 0
        if self.isShow == true {
            self.isShow = false
            if self.isSend && self.isSendSuccess {
                constant = Constant.commentViewHeight
                self.frame.size.height = Constant.commentViewHeight
                self.frame.origin.y = UIScreen.main.bounds.size.height - Constant.commentViewHeight
            } else {
                constant = self.frame.height
                self.frame.origin.y = UIScreen.main.bounds.size.height - self.frame.height
            }
        }
        self.delegate?.keyboardWillHide(constant: constant)
        if let userInfo = notification.userInfo {
            switch (userInfo[UIResponder.keyboardAnimationDurationUserInfoKey] as? NSNumber, userInfo[UIResponder.keyboardAnimationCurveUserInfoKey] as? NSNumber) {
            case let (.some(duration), .some(curve)):
                let options = UIView.AnimationOptions(rawValue: curve.uintValue)
                UIView.animate(withDuration: TimeInterval(duration.doubleValue),
                               delay: 0,
                               options: options,
                               animations: {
                                UIApplication.shared.keyWindow?.layoutIfNeeded()
                                return
                }, completion: { finished in
                    //TODO
                })
            default:
                break
            }
        }
    }
}
