//
//  LLAbacusSingleColum.swift
//  AbacusUtility
//
//  Created by LeoLe on 9/24/16.
//  Copyright © 2016 LeoLe. All rights reserved.
//

import UIKit

@objc
protocol LLAbacusSingleColumDelegate: NSObjectProtocol {
    optional func didChangeValueOfColum(index: Int, newValue: Int)
}

class LLAbacusSingleColum: BaseView {
    
    @IBOutlet weak var aboveView: UIView!
    @IBOutlet weak var belowView: UIView!
    @IBOutlet weak var uprightImageView: UIImageView!
    
    var update: Bool = false {
        didSet {
            self.setNeedsDisplay()
        }
    }
    
    weak var delegate: LLAbacusSingleColumDelegate?
    var orderNumber: Int = 0
    
    private var aboveBead: Bead?
    
    private var belowBead1: Bead?
    private var belowBead2: Bead?
    private var belowBead3: Bead?
    private var belowBead4: Bead?
    
    var heightBead: CGFloat = 0
    
    override func drawRect(rect: CGRect) {
        super.drawRect(rect)
        heightBead  = (rect.size.height - (1 * kWidthBorderAbacus)) / kNumberBeadAndSpace
        updateUI()
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        updateUI()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        self.setNeedsLayout()
        setups()
    }
    
    override class func loadFromXibFile() -> LLAbacusSingleColum? {
        let view  = NSBundle.mainBundle().loadNibNamed(self.className, owner: self, options: nil)[0]
        if view.isKindOfClass(LLAbacusSingleColum) {
            return view as? LLAbacusSingleColum
        }
        return nil
    }
    
}

//MARK: - Private Methods
extension LLAbacusSingleColum {
    private func setups() {
        setupUIs()
    }
    
    private func setupUIs() {
        
    }
    
    private func updateUI() {
        if aboveBead == nil {
            addBeads()
        }
        //Update UI
    }
    
    private func addBeads() {
        addAboveBead()
        addBelowBeads()
    }
}

//MARK: - Add beads
extension LLAbacusSingleColum {
    private func addAboveBead() {
        if aboveBead == nil {
            let rect = CGRectMake(0,0,CGRectGetWidth(self.frame), heightBead)
            let bead = Bead(frame: rect, minOrientation: .Up, minValue: 0, maxOrientation: .Down, maxValue: 5, currentOrientation: .Up, index: 1)
            bead.delegate = self
            self.aboveView.addSubview(bead)
            aboveBead = bead
        }
    }
    
    private func addBelowBeads() {
        let height = heightBead
        let width = CGRectGetWidth(self.frame)
        for i in 1...4 {
            let rect = CGRectMake(0,(height * CGFloat(i)),width, height)
            let bead = Bead(frame: rect, minOrientation: .Down, minValue: 0, maxOrientation: .Up, maxValue: 1, currentOrientation: .Down, index: i)
            bead.delegate = self
            self.belowView.addSubview(bead)
            assignBeads(index: i, bead: bead)
        }
    }
    
    private func assignBeads(index index: Int, bead: Bead) {
        switch index {
        case 1:
            belowBead1 = bead
            break
        case 2:
            belowBead2 = bead
            break
        case 3:
            belowBead3 = bead
            break
        case 4:
            belowBead4 = bead
            break
        default:
            break
        }
    }
}

//MARK: - Update UI when touch a bead
extension LLAbacusSingleColum {
    private func updateUIWhenTouchABead(bead: Bead) {
        if bead == aboveBead {
            updateUIWhenTouchAboveBead(bead)
        } else {
            updateUIWhenTouchBelowBeads(bead)
        }
        self.delegate?.didChangeValueOfColum?(self.orderNumber, newValue: currentValue())
    }
    
    func currentValue() -> Int {
        if aboveBead != nil && belowBead1 != nil && belowBead2 != nil && belowBead3 != nil && belowBead4 != nil {
            return aboveBead!.currentValue  + belowBead1!.currentValue + belowBead2!.currentValue + belowBead3!.currentValue + belowBead4!.currentValue
        }
        return 0
    }
}

//MARK: - Update UI when touch a above bead
extension LLAbacusSingleColum {
    private func updateUIWhenTouchAboveBead(bead: Bead) {
        if let aboveBead = aboveBead {
            var rect: CGRect?
            if aboveBead.currentOrientation == .Up {
                rect = CGRectMake(0,0,CGRectGetWidth(self.frame), heightBead)
            } else if aboveBead.currentOrientation == .Down {
                rect = CGRectMake(0, heightBead, CGRectGetWidth(self.frame), heightBead)
            }
            UIView.animateWithDuration(kIntervalAnimationBead, animations: {
                aboveBead.frame = rect!
            })
        }
    }
}

//MARK: - Update UI when touch a below bead
extension LLAbacusSingleColum {
    private func updateUIWhenTouchBelowBeads(bead: Bead) {
        if bead == belowBead1 {
            updateWhenTouchAtBelowBead1()
        } else if bead == belowBead2 {
            updateWhenTouchAtBelowBead2()
        } else if bead == belowBead3 {
            updateWhenTouchAtBelowBead3()
        } else if bead == belowBead4 {
            updateWhenTouchAtBelowBead4()
        }
    }
    
    private func updateBelowUIWithFrames(frame1 frame1: CGRect, frame2: CGRect, frame3: CGRect, frame4: CGRect) {
        UIView.animateWithDuration(kIntervalAnimationBead, animations: {
            self.belowBead1?.frame = frame1
            self.belowBead2?.frame = frame2
            self.belowBead3?.frame = frame3
            self.belowBead4?.frame = frame4
        })
    }
    
    private func updateWhenTouchAtBelowBead1() {
        var frame1: CGRect = belowBead1!.frame
        var frame2: CGRect = belowBead2!.frame
        var frame3: CGRect = belowBead3!.frame
        var frame4: CGRect = belowBead4!.frame
        
        let desOrientation: BeadOrientation = belowBead1?.currentOrientation ?? .Up
        if belowBead1?.currentOrientation == .Up {
            frame1 = CGRectMake(0,0,CGRectGetWidth(self.frame), heightBead)
        } else if belowBead1?.currentOrientation == .Down {
            frame1 = CGRectMake(0, 1 * heightBead,CGRectGetWidth(self.frame), heightBead)
            frame2 = frameBelowBead2WhenTouchABelowBead(desOrientation)
            frame3 = frameBelowBead3WhenTouchABelowBead(desOrientation)
            frame4 = frameBelowBead4WhenTouchABelowBead(desOrientation)
        }
        updateBelowUIWithFrames(frame1: frame1, frame2: frame2, frame3: frame3, frame4: frame4)
    }
    
    private func updateWhenTouchAtBelowBead2() {
        var frame1: CGRect = belowBead1!.frame
        var frame2: CGRect = belowBead2!.frame
        var frame3: CGRect = belowBead3!.frame
        var frame4: CGRect = belowBead4!.frame
        let desOrientation: BeadOrientation = belowBead2?.currentOrientation ?? .Up
        if belowBead2?.currentOrientation == .Up {
            frame2 = CGRectMake(0,1 * heightBead,CGRectGetWidth(self.frame), heightBead)
            
            frame1 = frameBelowBead1WhenTouchABelowBead(desOrientation)
        } else if belowBead2?.currentOrientation == .Down {
            frame2 = CGRectMake(0,2 * heightBead,CGRectGetWidth(self.frame), heightBead)
            frame3 = frameBelowBead3WhenTouchABelowBead(desOrientation)
            frame4 = frameBelowBead4WhenTouchABelowBead(desOrientation)
        }
        updateBelowUIWithFrames(frame1: frame1, frame2: frame2, frame3: frame3, frame4: frame4)
    }
    
    private func updateWhenTouchAtBelowBead3() {
        var frame1: CGRect = belowBead1!.frame
        var frame2: CGRect = belowBead2!.frame
        var frame3: CGRect = belowBead3!.frame
        var frame4: CGRect = belowBead4!.frame
        let desOrientation: BeadOrientation = belowBead3?.currentOrientation ?? .Up
        if belowBead3?.currentOrientation == .Up {
            frame3 = CGRectMake(0,2 * heightBead,CGRectGetWidth(self.frame), heightBead)
            frame1 = frameBelowBead1WhenTouchABelowBead(desOrientation)
            frame2 = frameBelowBead2WhenTouchABelowBead(desOrientation)
        } else if belowBead3?.currentOrientation == .Down {
            frame3 = CGRectMake(0,3 * heightBead,CGRectGetWidth(self.frame), heightBead)
            frame4 = frameBelowBead4WhenTouchABelowBead(desOrientation)
        }
        updateBelowUIWithFrames(frame1: frame1, frame2: frame2, frame3: frame3, frame4: frame4)
    }
    
    private func updateWhenTouchAtBelowBead4() {
        var frame1: CGRect = belowBead1!.frame
        var frame2: CGRect = belowBead2!.frame
        var frame3: CGRect = belowBead3!.frame
        var frame4: CGRect = belowBead4!.frame
        let desOrientation: BeadOrientation = belowBead4?.currentOrientation ?? .Up
        if belowBead4?.currentOrientation == .Up {
            frame4 = CGRectMake(0,3 * heightBead,CGRectGetWidth(self.frame), heightBead)
            frame1 = frameBelowBead1WhenTouchABelowBead(desOrientation)
            frame2 = frameBelowBead2WhenTouchABelowBead(desOrientation)
            frame3 = frameBelowBead3WhenTouchABelowBead(desOrientation)
        } else if belowBead4?.currentOrientation == .Down {
            frame4 = CGRectMake(0,4 * heightBead,CGRectGetWidth(self.frame), heightBead)
        }
        updateBelowUIWithFrames(frame1: frame1, frame2: frame2, frame3: frame3, frame4: frame4)
    }
    
    private func frameBelowBead1WhenTouchABelowBead(desOrientation: BeadOrientation) -> CGRect {
        belowBead1?.currentOrientation = desOrientation
        var rect: CGRect?
        if desOrientation == .Up {
            rect = CGRectMake(0,0,CGRectGetWidth(self.frame), heightBead)
        } else {
            rect = CGRectMake(0,heightBead,CGRectGetWidth(self.frame), heightBead)
        }
        return rect!
    }
    
    private func frameBelowBead2WhenTouchABelowBead(desOrientation: BeadOrientation) -> CGRect {
        belowBead2?.currentOrientation = desOrientation
        var rect: CGRect?
        if desOrientation == .Up {
            rect = CGRectMake(0,1 * heightBead,CGRectGetWidth(self.frame), heightBead)
        } else {
            rect = CGRectMake(0,2 * heightBead,CGRectGetWidth(self.frame), heightBead)
        }
        return rect!
    }
    
    private func frameBelowBead3WhenTouchABelowBead(desOrientation: BeadOrientation) -> CGRect {
        belowBead3?.currentOrientation = desOrientation
        var rect: CGRect?
        if desOrientation == .Up {
            rect = CGRectMake(0,2 * heightBead,CGRectGetWidth(self.frame), heightBead)
        } else {
            rect = CGRectMake(0,3 * heightBead,CGRectGetWidth(self.frame), heightBead)
        }
        return rect!
    }
    
    private func frameBelowBead4WhenTouchABelowBead(desOrientation: BeadOrientation) -> CGRect {
        belowBead4?.currentOrientation = desOrientation
        var rect: CGRect?
        if desOrientation == .Up {
            rect = CGRectMake(0,3 * heightBead,CGRectGetWidth(self.frame), heightBead)
        } else {
            rect = CGRectMake(0,4 * heightBead,CGRectGetWidth(self.frame), heightBead)
        }
        return rect!
    }
}

//MARK: - Bead Delegates
extension LLAbacusSingleColum: BeadDelegate {
    func didTouchInSideBead(bead: Bead, currentValue value: Int) {
        updateUIWhenTouchABead(bead)
        print("Did change a Bead become value: \(value)")
    }
}
