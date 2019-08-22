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
    
    fileprivate var viewModel = MainViewModel()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        self.configViewModel()
        self.configView()
        self.registerCell()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        self.addCommentView()
    }
    
    private func registerCell() {
        self.tableView.registerCellByNib(MessageCell.self)
        self.tableView.estimatedRowHeight = 40
    }
    
    private func configView() {
        self.navigationItem.title = "Messages"
    }
    
    private func configViewModel() {
        self.viewModel.delegate = self
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
    
    fileprivate func scrollToBottomTable() {
        DispatchQueue.main.async {
            if self.viewModel.numberOfRows() > 0 {
                self.tableView.scrollToRow(at: IndexPath(row: self.viewModel.numberOfRows() - 1, section: 0), at: UITableView.ScrollPosition.bottom, animated: false)
            }
        }
    }
}

extension MainViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        //TODO
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        //TODO
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
}

extension MainViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows()
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueCell(MessageCell.self, forIndexPath: indexPath) else {
            return UITableViewCell()
        }
        cell.configCell(model: self.viewModel.configViewModel(at: indexPath))
        return cell
    }
}

extension MainViewController: UIScrollViewDelegate {
    func scrollViewWillBeginDragging(_ scrollView: UIScrollView) {
        self.view.endEditing(true)
    }
}

extension MainViewController: CommentViewDelegate {
    func keyboardWillShow(constant: CGFloat) {
        self.tableViewBottomConstraint.constant = constant
        self.scrollToBottomTable()
    }
    
    func keyboardWillHide(constant: CGFloat) {
        self.tableViewBottomConstraint.constant = constant
        self.scrollToBottomTable()
    }
    
    func didChangeHeight(_ height: CGFloat) {
        if let commentView = self.commentView {
            self.tableViewBottomConstraint.constant = commentView.keyboardVisibleHeight + height
        }
        self.scrollToBottomTable()
    }
    
    func sendMessage(_ message: String) {
        let messages = self.viewModel.splitMessage(message)
        self.viewModel.appendMessages(messages)
        self.tableView.reloadData()
        if let commentView = self.commentView {
            if commentView.isShow {
                self.tableViewBottomConstraint.constant = commentView.keyboardVisibleHeight + commentView.frame.height
            }
        }
        self.scrollToBottomTable()
    }
}

extension MainViewController: MainViewModelDelegate {
    func didSplitMessagesSuccess() {
        self.commentView?.splitMessageSuccess(true)
    }
    
    func didSplitMessageFail(_ errorString: String?) {
        self.commentView?.splitMessageSuccess(false)
        self.showAlert(controller: self, title: "Message", message: errorString, comletion: nil)
    }
}
