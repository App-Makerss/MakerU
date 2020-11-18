//
//  NotificationTableViewCell.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 16/11/20.
//

import UIKit
class NotificationTableViewCell: UITableViewCell {
    static let reuseIdentifier = String(describing: self)
    
    var titleLabel: UILabel!
    var messageLabel: UILabel!
    var wasAtLabel: UILabel!
    
    private func initializeOutlets() {
        titleLabel = UILabel()
        titleLabel.setDynamicType(textStyle: .headline)
        
        messageLabel = UILabel()
        messageLabel.setDynamicType(textStyle: .callout)
        messageLabel.numberOfLines = 0
        messageLabel.setContentCompressionResistancePriority(.required, for: .vertical)
        
        wasAtLabel = UILabel()
        wasAtLabel.setDynamicType(textStyle: .subheadline)
        wasAtLabel.textColor = .secondaryLabel
        wasAtLabel.textAlignment = .right
    }
    
    func commonInit() {
        selectionStyle = .none
        initializeOutlets()
        
        
        let header = UIStackView(arrangedSubviews: [titleLabel, wasAtLabel])
        header.distribution = .fillProportionally
        header.heightAnchor.constraint(lessThanOrEqualToConstant: UIFont.maximumSize(for: .headline)).isActive = true
        
        let view = UIView()
        view.addSubview(messageLabel)
        messageLabel.setupConstraintsOnlyTo(to: view, leadingConstant: 0, topConstant: 0, trailingConstant: 0)
        messageLabel.bottomAnchor.constraint(lessThanOrEqualTo: view.bottomAnchor, constant: -14).isActive = true
        
        let rootGroup = UIStackView(axis: .vertical, arrangedSubviews: [header, view])
        rootGroup.distribution = .fillProportionally
        rootGroup.spacing = 9
        
        contentView.addSubview(rootGroup)
        
        rootGroup.setupConstraints(to: contentView, leadingConstant: 16, topConstant: 14, trailingConstant: -16)
        
    }
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }
}
