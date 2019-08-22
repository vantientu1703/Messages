//
//  ViewController.swift
//  Messages
//
//  Created by Văn Tiến Tú on 8/19/19.
//  Copyright © 2019 Văn Tiến Tú. All rights reserved.
//

import UIKit

//#3498DB

class MainViewController: BaseViewController {
    
    @IBOutlet weak var tableView: UITableView!
    fileprivate var commentView: CommentView?
    
    @IBOutlet weak var tableViewBottomConstraint: NSLayoutConstraint!
    fileprivate var keyboardVisibleHeight: CGFloat = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.addNotifications()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addCommentView()
    }
    
    private func addCommentView() {
        if self.commentView == nil {
            self.commentView = CommentView.fromNib()
            if let view = self.commentView {
                view.delegate = self
                let mainRect = UIScreen.main.bounds
                let height: CGFloat = Constant.commentViewHeight
                view.frame = CGRect(x: 0, y: mainRect.size.height - height, width: mainRect.width, height: height)
                view.setBorder(borderWidth: 0.5, color: .gray)
                self.view.addSubview(view)
            }
        }
    }
    
    deinit {
        self.removeNotifications()
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 10
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        return UITableViewCell()
    }
}

extension String {
    func height(withConstrainedWidth width: CGFloat, font: UIFont) -> CGFloat {
        let constraintRect = CGSize(width: width, height: .greatestFiniteMagnitude)
        let boundingBox = self.boundingRect(with: constraintRect, options: [.usesLineFragmentOrigin, .usesFontLeading], attributes: [NSAttributedString.Key.font: font], context: nil)
        
        return ceil(boundingBox.height)
    }
}

extension MainViewController {
    
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
                if let commentView = self.commentView, commentView.isShow == false {
                    commentView.isShow = true
                    commentView.keyboardVisibleHeight = self.keyboardVisibleHeight
                    self.tableViewBottomConstraint.constant += self.keyboardVisibleHeight
                    commentView.frame.origin.y -= self.keyboardVisibleHeight
                }
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
        if let commentView = self.commentView, commentView.isShow == true {
            commentView.isShow = false
            commentView.keyboardVisibleHeight = 0
            self.tableViewBottomConstraint.constant = Constant.commentViewHeight
            commentView.frame.size.height = Constant.commentViewHeight
            commentView.frame.origin.y = UIScreen.main.bounds.size.height - Constant.commentViewHeight
        }
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

extension MainViewController: CommentViewDelegate {
    func didChangeHeight(_ height: CGFloat) {
        self.tableViewBottomConstraint.constant = self.keyboardVisibleHeight + height
    }
}
