//
//  MainViewController.swift
//  AbacusUtility
//
//  Created by LeoLe on 9/22/16.
//  Copyright © 2016 LeoLe. All rights reserved.
//

import UIKit

class MainViewController: BaseViewController {

    @IBOutlet weak var resultView: UIView!
    @IBOutlet weak var abacusContainer: UIView!
    @IBOutlet weak var heightAbacusContainer: NSLayoutConstraint!
    
    weak var abacusView: LLAbacusView?
    var resultArray: [BaseLabel]?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.view.setNeedsDisplay()
        setHeightForAbacusView()
        addAbacusView()
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(self.didRotate(_:)), name: UIDeviceOrientationDidChangeNotification, object: nil)
    }
    
    deinit {
        NSNotificationCenter.defaultCenter().removeObserver(self)
    }
    
    func didRotate(noti: NSNotification) {
        if UIDeviceOrientationIsLandscape(UIDevice.currentDevice().orientation) {
            addComponentsResultView()
        }
    }
}

//MARK: - Abacus View
extension MainViewController {
    private func addComponentsResultView() {
        print("Frame Main 2: \(self.view.frame)")
        if resultArray == nil || resultArray?.count == 0 {
            resultArray = [BaseLabel]()
            let width = (CGRectGetWidth(self.view.frame) - (2 * kWidthBorderAbacus)) / kNumberOfColum
            let height = CGRectGetHeight(self.view.frame) - heightAbacusContainer.constant
            for i in 0..<Int(kNumberOfColum) {
                let label = BaseLabel(frame: CGRectMake(kWidthBorderAbacus + (CGFloat(i) * width), 0, width, height))
                resultView.addSubview(label)
                label.translatesAutoresizingMaskIntoConstraints = true
                label.font = UIFont.boldSystemFontOfSize(50)
                label.text = "0"
                label.textAlignment = .Center
                resultArray?.append(label)
            }
        }
    }
}

//MARK: - Abacus View
extension MainViewController {
    private func setHeightForAbacusView() {
        let widthColum = (CGRectGetWidth(self.abacusContainer.frame) - (2 * kWidthBorderAbacus)) / kNumberOfColum
        heightAbacusContainer.constant = (kNumberOfColum * widthColum * (2 / 3.0)) + (3 * kWidthBorderAbacus)
    }
    
    private func addAbacusView() {
        print("Frame Main 1: \(self.view.frame)")
        if abacusView == nil, let view = LLAbacusView.loadFromXibFile() {
            abacusContainer.addSubview(view)
            view.translatesAutoresizingMaskIntoConstraints = false
            view.snp_makeConstraints(closure: { (make) in
                make.top.left.bottom.right.equalTo(0)
            })
            view.delegate = self
            abacusView = view
        }
    }
}

//MARK: - AbacusView Delegate
extension MainViewController: LLAbacusViewDelegate {
    func didChangeValueOfColum(index: Int, newValue: Int) {
        if let labels = resultArray where labels.count > index {
            labels[index].text = String(newValue)
        }
    }
}




