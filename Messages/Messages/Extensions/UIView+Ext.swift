//
//  UIView+Ext.swift
//  BaseProject
//
//  Created by Văn Tiến Tú on 11/7/18.
//  Copyright © 2018 Văn Tiến Tú. All rights reserved.
//

import UIKit

protocol ResponseUIView {}

extension ResponseUIView where Self: UIView {
    
    private static func fromNib<T: UIView>(_ type: T.Type) -> T? {
        if let view = Bundle.main.loadNibNamed(type.identifier, owner: nil, options: nil)?.first, let _view = view as? T {
            return _view
        } else {
            return nil
        }
    }
    
    static func fromNib() -> Self? {
        return fromNib(self)
    }
}

extension UIView: ResponseUIView {
    
    func setRaidus(_ radius: CGFloat = 0) {
        self.layer.cornerRadius = radius
    }
    
    func setBorder(borderWidth: CGFloat = 0, color: UIColor = .clear) {
        self.layer.borderWidth = borderWidth
        self.layer.borderColor = color.cgColor
    }
}
