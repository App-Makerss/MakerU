//
//  UIContentSizeCategory+Extensions.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 26/11/20.
//

import UIKit

extension UIContentSizeCategory: Comparable {
    
    func howMuchMoreThanLargeCategory() -> Int {
        switch self {
            case .extraLarge:
                return 1
            case .extraExtraLarge:
                return 2
            case UIContentSizeCategory.extraExtraExtraLarge...UIContentSizeCategory.accessibilityExtraExtraExtraLarge:
                return 3
            default:
                return 0
        }
    }
}
