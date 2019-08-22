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
}

class CommentView: UIView {
    
    @IBOutlet weak var commentTextField: TextViewMaster!
    @IBOutlet weak var containView: UIView!
    
    weak var delegate: CommentViewDelegate?
    
    var isShow = false
    var keyboardVisibleHeight: CGFloat = 0
    
    fileprivate var oringinPoint = CGPoint.zero
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.configView()
    }
    
    private func configView() {
        self.containView.setRaidus(20)
        self.commentTextField.delegate = self
        self.commentTextField.maxHeight = 300
    }
    
    @IBAction func sendAction(_ sender: Any) {
        self.commentTextField.text = ""
        self.commentTextField.resignFirstResponder()
        self.layoutIfNeeded()
    }
}

extension CommentView: UITextViewDelegate {
    
    func textViewDidChange(_ textView: UITextView) {
        guard let font = textView.font else { return }
        if self.oringinPoint == .zero {
            self.oringinPoint = self.frame.origin
        }
        let constant: CGFloat = Constant.commentViewHeight / 2
        var textHeight = textView.sizeThatFits(CGSize(width: textView.bounds.width, height: CGFloat.greatestFiniteMagnitude)).height
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
    }
}

extension CommentView: TextViewMasterDelegate {
    func growingTextView(growingTextView: TextViewMaster, willChangeHeight height: CGFloat) {
        self.layoutIfNeeded()
    }
}
