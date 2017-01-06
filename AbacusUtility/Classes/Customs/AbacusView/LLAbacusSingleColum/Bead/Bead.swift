//
//  Bead.swift
//  AbacusUtility
//
//  Created by LeoLe on 9/24/16.
//  Copyright © 2016 LeoLe. All rights reserved.
//

import UIKit

enum BeadOrientation {
    case Up
    case Down
}

@objc protocol BeadDelegate: NSObjectProtocol {
    optional func didTouchInSideBead(bead: Bead, currentValue value: Int) -> Void
}

class Bead: UIButton {
    //MARK: - Variables
    var index: Int = 1
    var minOrientation: BeadOrientation = .Up
    var maxOrientation: BeadOrientation = .Down
    var currentOrientation: BeadOrientation = .Up {
        didSet {
            updateCurrentValue()
        }
    }
    var minValue: Int = 0
    var maxValue: Int = 5
    
    var currentValue: Int = 0
    
    weak var delegate: BeadDelegate?
    //MARK: - Inits
    override init(frame: CGRect) {
        super.init(frame: frame)
        setups()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        setups()
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        updateUI()
    }
    
    convenience init(frame: CGRect, minOrientation: BeadOrientation, minValue: Int, maxOrientation: BeadOrientation, maxValue: Int, currentOrientation: BeadOrientation, index: Int) {
        self.init(frame: frame)
        self.minOrientation = minOrientation
        self.minValue = minValue
        self.maxOrientation = maxOrientation
        self.maxValue = maxValue
        self.currentOrientation = currentOrientation
        self.index = index
    }
}

//MARK: - Private Methods
extension Bead {
    private func setups() {
        self.setTitle(nil, forState: .Normal)
        self.addTarget(self, action: #selector(self.tapBead(_:)), forControlEvents: .TouchUpInside)
        self.adjustsImageWhenHighlighted = false
    }
    
    private func updateUI() {
        self.layer.cornerRadius = 15.0
        self.clipsToBounds = true
        setupLayers()
    }
    
    private func setupLayers() {
        let leftColor = colorRGB(red: 241, green: 121, blue: 100).CGColor as CGColorRef
        let rightColor = colorRGB(red: 181, green: 0, blue: 0).CGColor as CGColorRef
        let gradientLayer: CAGradientLayer = CAGradientLayer()
        gradientLayer.frame = self.bounds
        gradientLayer.colors = [leftColor, rightColor]
        self.layer.addSublayer(gradientLayer)
    }
    
    private func updateCurrentValue() {
        if currentOrientation == minOrientation {
            currentValue = minValue
        } else if currentOrientation == maxOrientation {
            currentValue = maxValue
        }
    }
}

//MARK: - Action touch
extension Bead {
    func tapBead(sender: UIButton) {
        print("Tap in bead")
        didTapBead()
    }
}

//MARK: - Update UI
extension Bead {
    private func didTapBead() {
        updateCurrentOrientationWhenTouch()
        self.delegate?.didTouchInSideBead?(self, currentValue: currentValue)
    }
    
    private func updateCurrentOrientationWhenTouch() {
        if currentOrientation == minOrientation {
            currentOrientation = maxOrientation
            
        } else if currentOrientation == maxOrientation {
            currentOrientation = minOrientation
            
        }
    }
}
