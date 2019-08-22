//
//  UIViewController+Ext.swift
//  BaseProject
//
//  Created by Văn Tiến Tú on 11/7/18.
//  Copyright © 2018 Văn Tiến Tú. All rights reserved.
//

import UIKit

protocol ResponseUIViewController {}

extension ResponseUIViewController where Self: UIViewController {
    static func fromNib() -> Self {
        return self.init(nibName: String(describing: self), bundle: nil)
    }
    
    static func fromStoryboard(_ storyboardName: UIStoryboard.StoryboardName, withIdentifier: String = Self.identifier) -> Self? {
        return Self.fromStoryboard(self, storyboardName: storyboardName, withIdentifier: withIdentifier)
    }
    
    private static func fromStoryboard<T: UIViewController>(_ type: T.Type, storyboardName: UIStoryboard.StoryboardName, withIdentifier: String?) -> T? {
        let storyboard = UIStoryboard(storyboard: storyboardName, bundle: nil)
        return storyboard.instantiateViewController(type)
    }
}

extension UIViewController: ResponseUIViewController {
    func showAlert(controller: UIViewController, title: String?, message: String?, comletion: (() -> ())?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: "Ok", style: .default) { (_) in
            comletion?()
        }
        alertController.addAction(action)
        controller.present(alertController, animated: true, completion: nil)
    }
}
