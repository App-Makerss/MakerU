//
//  EquipmentCollectionViewCell.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 26/10/20.
//

import UIKit

class EquipmentCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: EquipmentCollectionViewCell.self)
    
    private let containerView = UIView()
    
    let title: UILabel = {
        let lbl = UILabel()
        lbl.text = "Termoformadora"
        lbl.setDynamicType(font: .systemFont(style: .subheadline, weight: .medium), textStyle: .subheadline)
        return lbl
    }()
    
    let subtitle: UILabel = {
        let lbl = UILabel()
        lbl.text = "290x350 mm"
        lbl.setDynamicType(font: .systemFont(style: .caption2, weight: .medium), textStyle: .caption2)
        return lbl
    }()
    
    
    let imageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "testEquip"))
        imgView.contentMode = .scaleAspectFill
        imgView.translatesAutoresizingMaskIntoConstraints = false
        return imgView
    }()
    
    private func contentStackView() -> UIStackView {
        
        let footer = UIStackView(arrangedSubviews: [title,subtitle])
        footer.axis = .vertical
        footer.alignment = .leading
        footer.distribution = .fillProportionally

        let footerView = UIView()
        footerView.addSubview(footer)
        footer.setupConstraints(to: footerView, leadingConstant: 8)
        
        let stack = UIStackView(arrangedSubviews: [imageView, footerView])
        stack.axis = .vertical
        stack.distribution = .fill
        stack.spacing = 8
        
        imageView.heightAnchor.constraint(equalTo: stack.heightAnchor, multiplier: 0.75).isActive = true
        
        return stack
    }
    
    func commonInit() {
        
        let contentStack = contentStackView()
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true

        containerView.addSubview(contentStack)
        contentStack.setupConstraints(to: containerView)
        contentView.addSubview(containerView)
        containerView.setupConstraints(to: contentView)

        containerView.backgroundColor = .systemBackground
        self.backgroundColor = .clear
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.masksToBounds = false
        self.layer.shadowRadius = 30 / 2.0
        self.layer.shadowOpacity = 0.10
        self.layer.shadowOffset = CGSize(width: 0, height: 3)
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        commonInit()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init notImplemented yet EquipmentCollectionViewCell")
    }
    
}
