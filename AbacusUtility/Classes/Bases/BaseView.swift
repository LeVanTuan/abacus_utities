//
//  BaseView.swift
//  AbacusUtility
//
//  Created by LeoLe on 9/22/16.
//  Copyright © 2016 LeoLe. All rights reserved.
//

import UIKit

class BaseView: UIView {

    class func loadFromXibFile() -> BaseView? {
        let view  = NSBundle.mainBundle().loadNibNamed(self.className, owner: self, options: nil)[0]
        if view.isKindOfClass(BaseView) {
            return view as? BaseView
        }
        return nil
    }
}
