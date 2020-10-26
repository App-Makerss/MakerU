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
    
}

