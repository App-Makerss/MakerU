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
        dp.tintColor = .systemPurple
        dp.minuteInterval = 5
        return dp
    }()
    
    
    var textLbl: UILabel = {
        let textLabel = UILabel()
        textLabel.setDynamicType(font: .systemFont(style: .body, weight: .semibold), textStyle: .body)
        textLabel.textColor = .label
        
        return textLabel
    }()
    
    func commonInit() {
        let contentStackView = UIStackView()
        contentStackView.addArrangedSubview(textLbl)
        contentStackView.addArrangedSubview(timePicker)
        contentStackView.alignment = .center
        contentStackView.distribution = .fill
        contentView.addSubview(contentStackView)
        contentStackView.setupConstraints(to: contentView, leadingConstant: 16, trailingConstant: -8)
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
