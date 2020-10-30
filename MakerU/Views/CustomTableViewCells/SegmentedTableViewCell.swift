//
//  SegmentedTableViewCell.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 20/10/20.
//

import UIKit

class SegmentedTableViewCell: UITableViewCell {
    
    var timePicker: UIDatePicker = {
       let dp = UIDatePicker()
        dp.datePickerMode = .time
        dp.preferredDatePickerStyle = .inline
        return dp
    }()
    
    
    var textLbl: UILabel = {
        let textLabel = UILabel()
        textLabel.setDynamicType(font: .systemFont(style: .body))
        textLabel.textColor = .label
        return textLabel
    }()
    
    func commonInit() {
        let stackView = UIStackView(arrangedSubviews: [textLbl, timePicker])
        stackView.alignment = .center
        stackView.distribution = .fill
        contentView.addSubview(stackView)
        stackView.setupConstraints(to: contentView, leadingConstant: 13, trailingConstant: -8)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        self.selectionStyle = .none
        commonInit()
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
