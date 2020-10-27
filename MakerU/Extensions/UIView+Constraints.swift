//
//  UIView+Constraints.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 23/10/20.
//

import Foundation
import UIKit

extension UIView {
    func setupConstraints(to parent: UIView,
                        leadingConstant: CGFloat = 0,
                        topConstant: CGFloat = 0,
                        trailingConstant: CGFloat = 0,
                        bottomConstant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leadingConstant).isActive = true
        self.topAnchor.constraint(equalTo: parent.topAnchor, constant: topConstant).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: trailingConstant).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottomConstant).isActive = true
    }
    
    func setupConstraintsRelatedToSafeArea(to parent: UIView,
                          leadingConstant: CGFloat = 0,
                          topConstant: CGFloat = 0,
                          trailingConstant: CGFloat = 0,
                          bottomConstant: CGFloat = 0) {
        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leadingConstant).isActive = true
        self.topAnchor.constraint(equalTo: parent.safeAreaLayoutGuide.topAnchor, constant: topConstant).isActive = true
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: trailingConstant).isActive = true
        self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottomConstant).isActive = true
    }
}
