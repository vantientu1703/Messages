//
//  UIStoryboard+Ext.swift
//  BaseProject
//
//  Created by Văn Tiến Tú on 11/7/18.
//  Copyright © 2018 Văn Tiến Tú. All rights reserved.
//

import UIKit

extension UIStoryboard {
    
    enum StoryboardName: String {
        
        case main
        
        var identifier: String {
            switch self {
            case .main:
                return "Main"
            }
        }
    }
    
    convenience init(storyboard: StoryboardName, bundle: Bundle? = nil) {
        self.init(name: storyboard.identifier, bundle: bundle)
    }
    
    class func storyboard(_ storyboard: StoryboardName, bundle: Bundle? = nil) -> UIStoryboard {
        return UIStoryboard(name: storyboard.identifier, bundle: bundle)
    }
    
    func instantiateViewController<T: UIViewController>(_ type: T.Type) -> T? {
        return instantiateViewController(withIdentifier: type.identifier) as? T
    }
}
