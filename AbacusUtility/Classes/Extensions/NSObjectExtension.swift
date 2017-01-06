//
//  NSObjectExtension.swift
//  AbacusUtility
//
//  Created by LeoLe on 9/22/16.
//  Copyright © 2016 LeoLe. All rights reserved.
//

import UIKit

extension NSObject {
    public class var className: String {
        return NSStringFromClass(self).componentsSeparatedByString(".").last!
    }
    
    public var className: String {
        return NSStringFromClass(self.dynamicType).componentsSeparatedByString(".").last!
    }
    
}
