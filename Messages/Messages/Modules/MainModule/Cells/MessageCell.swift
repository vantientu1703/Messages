//
//  MessageCell.swift
//  Messages
//
//  Created by Văn Tiến Tú on 8/23/19.
//  Copyright © 2019 Văn Tiến Tú. All rights reserved.
//

import UIKit

class MessageCell: UITableViewCell {

    @IBOutlet weak var messageLabel: UILabel!
    @IBOutlet weak var containView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        self.configView()
    }
    
    func configView() {
        self.containView.setRaidus(16)
    }
    
    func configCell(model: MessageCellModel) {
        self.messageLabel.text = model.content
    }
}
