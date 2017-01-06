//
//  LLAbacusView.swift
//  AbacusUtility
//
//  Created by LeoLe on 9/22/16.
//  Copyright © 2016 LeoLe. All rights reserved.
//

import UIKit

@objc
protocol LLAbacusViewDelegate: NSObjectProtocol {
    optional func didChangeValueOfColum(index: Int, newValue: Int)
}

class LLAbacusView: BaseView {
    
    @IBOutlet weak var mainContainer: UIView!
    //MARK: - Variables
    var result: Int = 0
    var columArray: [LLAbacusSingleColum]?
    
    weak var delegate: LLAbacusViewDelegate?
    
    override class func loadFromXibFile() -> LLAbacusView? {
        let view  = NSBundle.mainBundle().loadNibNamed(self.className, owner: self, options: nil)[0]
        if view.isKindOfClass(LLAbacusView) {
            return view as? LLAbacusView
        }
        return nil
    }
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        addColums()
        setupLayers()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setNeedsDisplay()
        setups()
    }
    
}

//MARK: - Private Methods
extension LLAbacusView {
    private func setups() {
        setupUIs()
    }
    
    private func setupUIs() {
        self.layer.borderColor = UIColor.grayColor().CGColor
        self.layer.borderWidth = 0.5
    }
    
    private func setupLayers() {
        let leftColor = colorRGB(red: 112, green: 3, blue: 3).CGColor as CGColorRef
        let rightColor = colorRGB(red: 211, green: 109, blue: 0).CGColor as CGColorRef
        let gradient: CAGradientLayer = CAGradientLayer()
        gradient.frame = self.bounds
        gradient.colors = [leftColor, rightColor]
        self.layer.insertSublayer(gradient, atIndex: 0)
    }
    
    private func addColums() {
        if columArray == nil || columArray?.count == 0 {
            columArray = [LLAbacusSingleColum]()
            let width = mainContainer.frame.width / kNumberOfColum
            print("Frame View: \(self.frame)")
            for i in 0..<Int(kNumberOfColum) {
                if let view = LLAbacusSingleColum.loadFromXibFile() {
                    view.frame = CGRectMake(CGFloat(i) * width, 0, width, mainContainer.frame.height)
                    mainContainer.addSubview(view)
                    view.delegate = self
                    view.orderNumber = i
                    view.translatesAutoresizingMaskIntoConstraints = true
                    columArray?.append(view)
                }
            }
        }
    }
}

//MARK: - Public Methods
extension LLAbacusView {
    
}

//MARK: - LLAbacusSingleColum Delegate
extension LLAbacusView: LLAbacusSingleColumDelegate {
    func didChangeValueOfColum(index: Int, newValue: Int) {
        self.delegate?.didChangeValueOfColum?(index, newValue: newValue)
    }
}
