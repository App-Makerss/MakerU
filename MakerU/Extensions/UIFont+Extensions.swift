//
//  UILabel+Extensions.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 24/10/20.
//

import Foundation
import UIKit

extension UILabel {
    
    var isTruncated: Bool {
        guard let labelText = text, bounds.size.height > 0 else {return false}
        let labelTextSize = (labelText as NSString).boundingRect(
            with: CGSize(width: frame.size.width, height: .greatestFiniteMagnitude),
            options: .usesLineFragmentOrigin,
            attributes: [.font: font!],
            context: nil).size
        
        return labelTextSize.height > bounds.size.height
    }
    
    func setDynamicType(font: UIFont, textStyle: UIFont.TextStyle? = nil){
        self.adjustsFontForContentSizeCategory = true
        var style: UIFont.TextStyle!
        if textStyle == nil {
            style = font.textStyle
        }else {
            style = textStyle
        }
        self.font = UIFontMetrics(forTextStyle: style).scaledFont(for: font,maximumPointSize: UIFont.maximumSize(for: style))
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

