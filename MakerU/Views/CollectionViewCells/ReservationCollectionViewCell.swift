//
//  ReservationCollectionViewCell.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 26/11/20.
//

import UIKit

class ReservationCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: ReservationCollectionViewCell.self)
    
    private let containerView = UIView()
    
    let weekdayLabel: UILabel = {
        let lbl = UILabel()
        lbl.textColor = .systemRed
        lbl.setDynamicType(textStyle: .caption2, weight: .semibold)
        return lbl
    }()
    
    let day: UILabel = {
        let lbl = UILabel()
        lbl.setDynamicType(textStyle: .title1)
        return lbl
    }()
    let item: ItemView = ItemView()
    
    
    func commonInit() {
        let contentStack = UIStackView(axis: .vertical, arrangedSubviews: [weekdayLabel, day, item])
        contentStack.alignment = .leading
        contentStack.distribution = .fillProportionally
        contentStack.spacing = 8
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        
        containerView.addSubview(contentStack)
        contentStack.setupConstraints(to: containerView, leadingConstant: 12, topConstant: 12, trailingConstant: -12, bottomConstant: -12)
        contentView.addSubview(containerView)
        containerView.setupConstraints(to: contentView)
        
        containerView.backgroundColor = .systemBackground
        self.backgroundColor = .clear
        
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
