//
//  UIViewExtentions.swift
//  GitHubU
//
//  Created by BogdanTymoshenko on 4/3/17.
//  Copyright © 2017 AmicableSoft. All rights reserved.
//

import UIKit

extension UIImageView {
    func applyCircleMask() {
        let mask = CAShapeLayer()
        mask.fillRule = kCAFillRuleEvenOdd
        let maskPath = UIBezierPath(
            roundedRect: CGRect(origin:CGPoint.zero, size:bounds.size),
            cornerRadius: bounds.width * 0.5
        )
        mask.path = maskPath.cgPath
        layer.mask = mask
    }
}

