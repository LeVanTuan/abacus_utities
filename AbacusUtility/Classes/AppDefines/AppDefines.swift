//
//  AppDefines.swift
//  AbacusUtility
//
//  Created by LeoLe on 9/22/16.
//  Copyright © 2016 LeoLe. All rights reserved.
//

import UIKit

//MARK: - Keys
let kNumberOfColum: CGFloat = 13.0
let kWidthBorderAbacus: CGFloat = 10.0
let kNumberBeadAndSpace: CGFloat = 7.0
let kIntervalAnimationBead: NSTimeInterval = 0.1


//MARK: - Functions
func colorRGB(red red: Int, green: Int, blue: Int, alpha: CGFloat = 1.0) -> UIColor {
    return UIColor(red: CGFloat(red) / 255.0, green: CGFloat(green) / 255.0, blue: CGFloat(blue) / 255.0, alpha: alpha)
}