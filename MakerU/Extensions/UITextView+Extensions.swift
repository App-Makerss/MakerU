//
//  UITextView+Extensions.swift
//  MakerU
//
//  Created by Victoria Faria on 12/11/20.
//

import UIKit

extension UITextView{

    /// Resize the placeholder when the UITextView bounds change
    override open var bounds: CGRect {
        didSet {
            self.resizePlaceholder()
        }
    }

    /// The UITextView placeholder text
    public var placeholder: String? {
        get {
            var placeholderText: String?

            if let placeholderLabel = self.viewWithTag(100) as? UILabel {
                placeholderText = placeholderLabel.text
            }

            return placeholderText
        }
        set {
            if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
                placeholderLabel.text = newValue
                placeholderLabel.sizeToFit()
            } else {
                self.addPlaceholder(newValue)
            }
        }
    }

    /// When the UITextView did change, show or hide the label based on if the UITextView is empty or not
    ///
    /// - Parameter textView: The UITextView that got updated
    @objc private func managePlaceholderVisibility(){
        if let placeholderLabel = self.viewWithTag(100) as? UILabel {
            placeholderLabel.isHidden = !self.text.isEmpty
            self.accessibilityValue = self.text.isEmpty ? placeholder : self.text
        }
    }

    /// Resize the placeholder UILabel to make sure it's in the same position as the UITextView text
    private func resizePlaceholder() {
        if let placeholderLabel = self.viewWithTag(100) as! UILabel? {
            let labelX = self.textContainer.lineFragmentPadding
            let labelY = self.textContainerInset.top - 6
            let labelWidth = self.frame.width - (labelX * 2)
            let labelHeight = self.frame.height * 0.2
            
            placeholderLabel.frame = CGRect(x: labelX, y: labelY, width: labelWidth, height: labelHeight)
        }
    }

    /// Adds a placeholder UILabel to this UITextView
    private func addPlaceholder(_ placeholderText: String?) {
        let placeholderLabel = UILabel()

        placeholderLabel.text = placeholderText
        placeholderLabel.sizeToFit()
        placeholderLabel.numberOfLines = 0

        placeholderLabel.font = self.font
        placeholderLabel.textColor = UIColor.lightGray
        placeholderLabel.tag = 100
        placeholderLabel.isAccessibilityElement = false
        placeholderLabel.isHidden = !self.text.isEmpty

        self.addSubview(placeholderLabel)
        self.resizePlaceholder()

        NotificationCenter.default.addObserver(self, selector: #selector(self.managePlaceholderVisibility), name: NSNotification.Name(rawValue: "managePlaceholderVisibility"), object: nil)
    }
}
