//
//  NSLayoutConstraint+Extensions.swift
//  covid19-challenge
//
//  Created by Bruno Cardoso Ambrosio on 28/04/20.
//  Copyright © 2020 João Victor Batista. All rights reserved.
//

import UIKit

extension NSLayoutConstraint {
    func constraintWithMultiplier(_ multiplier: CGFloat) -> NSLayoutConstraint {
        return NSLayoutConstraint(item: self.firstItem!, attribute: self.firstAttribute, relatedBy: self.relation, toItem: self.secondItem, attribute: self.secondAttribute, multiplier: multiplier, constant: self.constant)
    }
}
