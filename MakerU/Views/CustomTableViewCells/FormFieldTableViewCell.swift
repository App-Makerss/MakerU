//
//  FormFieldTableViewCell.swift
//  HabitMaker
//
//  Created by Bruno Cardoso Ambrosio on 18/04/20.
//  Copyright © 2020 Bruno Cardoso Ambrosio. All rights reserved.
//

import UIKit

class FormFieldTableViewCell: UITableViewCell {

    let label: UILabel!
    let value: UITextField!

    let padding: CGFloat = 16
    
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        label = UILabel()
        value = UITextField()
        
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        label = UILabel()
        value = UITextField()
        
        super.init(coder: coder)
        
        commonInit()
    }
    
    func commonInit() {
        selectionStyle = .none
        label.setDynamicType(font: .systemFont(style: .body))
        value.setDynamicType(font: .systemFont(style: .body))
        label.setContentHuggingPriority(.init(251), for: .horizontal)
        
        let layoutStackView = UIStackView(arrangedSubviews: [label,value])
        layoutStackView.translatesAutoresizingMaskIntoConstraints = false
        
        contentView.addSubview(layoutStackView)
        
        layoutStackView.setupConstraints(to: contentView, leadingConstant: padding, trailingConstant: -padding)
        layoutStackView.heightAnchor.constraint(greaterThanOrEqualToConstant: 44).isActive = true
        
        value.textAlignment = .right
        value.clearButtonMode = .whileEditing
        value.tintColor = .systemPurple
        value.delegate = self
        value.textColor = .secondaryLabel
    }
    
    /// Toggles its UITextField isEnable
    func toggleFieldEnabled() {
        value.isEnabled = !value.isEnabled
    }
}
extension FormFieldTableViewCell: UITextFieldDelegate {
    
    func textFieldDidEndEditing(_ textField: UITextField, reason: UITextField.DidEndEditingReason) {
        value.textColor = .secondaryLabel
        
    }
    func textFieldDidBeginEditing(_ textField: UITextField) {
        value.textColor = .label
    }
}
