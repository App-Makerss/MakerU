//
//  UIStackView+Extensions.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 09/11/20.
//

import UIKit

extension UIStackView {
    convenience init(axis: NSLayoutConstraint.Axis ,arrangedSubviews: [UIView]) {
        self.init(arrangedSubviews: arrangedSubviews)
        self.axis = axis
    }
}
