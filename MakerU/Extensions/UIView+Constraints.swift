//
//  UIView+Constraints.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 23/10/20.
//

import Foundation
import UIKit

extension UIView {
    
    /// Configures the view constraints to a parent view setting all the side anchors
    /// - Parameters:
    ///   - parent: parent view of this view
    ///   - leadingConstant: contantValue to leading, default is 0
    ///   - topConstant: contantValue to top, default is 0
    ///   - trailingConstant: contantValue to trailing, default is 0
    ///   - bottomConstant: contantValue to bottom, default is 0
    ///   - topSafeArea: indicates if the top anchor must or not consider the parent safe area, default is false
    ///   - bottomSafeArea: indicates if the bottom anchor must or not consider the parent safe area, default is false
    func setupConstraints(to parent: UIView,
                          leadingConstant: CGFloat = 0,
                          topConstant: CGFloat = 0,
                          trailingConstant: CGFloat = 0,
                          bottomConstant: CGFloat = 0,
                          topSafeArea: Bool = false,
                          bottomSafeArea: Bool = false) {
        let safeAreaAnchors = parent.safeAreaLayoutGuide

        self.translatesAutoresizingMaskIntoConstraints = false
        self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leadingConstant).isActive = true
        if topSafeArea {
            self.topAnchor.constraint(equalTo: safeAreaAnchors.topAnchor, constant: topConstant).isActive = true
        }else {
            self.topAnchor.constraint(equalTo: parent.topAnchor, constant: topConstant).isActive = true
        }
        self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: trailingConstant).isActive = true
        if topSafeArea {
            self.bottomAnchor.constraint(equalTo: safeAreaAnchors.bottomAnchor, constant: bottomConstant).isActive = true
        }else {
            self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottomConstant).isActive = true
        }
    }
    
    
    /// Configures the view constraints to a parent view and setting only the constraints that aren't nil,  can consider Y (top and bottom) save areas
    /// - Parameters:
    ///   - parent: parent view of this view
    ///   - leadingConstant: contantValue to leading, default is nil
    ///   - topConstant: contantValue to top, default is nil
    ///   - trailingConstant: contantValue to trailing, default is nil
    ///   - bottomConstant: contantValue to bottom, default is nil
    ///   - topSafeArea: indicates if the top anchor must or not consider the parent safe area, default is false
    ///   - bottomSafeArea: indicates if the bottom anchor must or not consider the parent safe area, default is false
    func setupConstraintsOnlyTo(to parent: UIView,
                                leadingConstant: CGFloat? = nil,
                                topConstant: CGFloat? = nil,
                                trailingConstant: CGFloat? = nil,
                                bottomConstant: CGFloat? = nil,
                                topSafeArea: Bool = false,
                                bottomSafeArea: Bool = false) {
        if leadingConstant == nil && topConstant == nil && trailingConstant == nil && bottomConstant == nil {
            return
        }
        let safeAreaAnchors = parent.safeAreaLayoutGuide
        
        self.translatesAutoresizingMaskIntoConstraints = false
        if let leadingConstant = leadingConstant {
            self.leadingAnchor.constraint(equalTo: parent.leadingAnchor, constant: leadingConstant).isActive = true
        }
        if let topConstant = topConstant {
            if topSafeArea {
                self.topAnchor.constraint(equalTo: safeAreaAnchors.topAnchor, constant: topConstant).isActive = true
            }else {
                self.topAnchor.constraint(equalTo: parent.topAnchor, constant: topConstant).isActive = true
            }
        }
        if let trailingConstant = trailingConstant {
            self.trailingAnchor.constraint(equalTo: parent.trailingAnchor, constant: trailingConstant).isActive = true
        }
        if let bottomConstant = bottomConstant {
            if bottomSafeArea {
                self.bottomAnchor.constraint(equalTo: safeAreaAnchors.bottomAnchor, constant: bottomConstant).isActive = true
            }else {
                self.bottomAnchor.constraint(equalTo: parent.bottomAnchor, constant: bottomConstant).isActive = true
            }
        }
    }
}
