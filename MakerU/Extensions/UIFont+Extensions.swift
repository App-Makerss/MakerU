//
//  UIFont+Extensions.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 16/10/20.
//

import UIKit

extension UIFont {
    static func systemFont(style: UIFont.TextStyle, weight: UIFont.Weight? = nil) -> UIFont {

        guard let weight = weight else {
            return UIFont.preferredFont(forTextStyle: style)
        }
        return UIFont.systemFont(ofSize: UIFont.preferredFont(forTextStyle: style).pointSize, weight: weight)
    }
}
