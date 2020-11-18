//
//  UITextField+Extensions.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 03/11/20.
//
import Foundation
import UIKit

extension UITextField {
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
