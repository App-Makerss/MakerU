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
    
    var textStyle: UIFont.TextStyle {
        get{
            let txtStyle = self.fontDescriptor.fontAttributes[.textStyle] as! String
            return UIFont.TextStyle(rawValue: txtStyle)
        }
    }
    
     static func maximumSize(for textStyle: UIFont.TextStyle) -> CGFloat {
        switch textStyle {
            case .largeTitle:
                return 40
            case  .title1:
                return 34
            case .title2:
                return 28
            case .title3:
                return 26
            case .headline:
                return 23
            case .body:
                return 23
            case .callout:
                return 22
            case .subheadline:
                return 21
            case .footnote:
                return 19
            case .caption1:
                return 18
            case .caption2:
                return 17
            default:
                return 0
        }
    }
}
