//
//  RoomCollectionViewCell.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 26/10/20.
//

import UIKit

class RoomCollectionViewCell: UICollectionViewCell {
    static let reuseIdentifier = String(describing: RoomCollectionViewCell.self)

    private let containerView = UIView()
    
    let imageView: UIImageView = {
        let imgView = UIImageView(image: UIImage(named: "meetRoomTest"))
        imgView.contentMode = .scaleAspectFill
        
        return imgView
        
    }()
    
    let title: UILabel = {
        let lbl = UILabel()
        lbl.setDynamicType(font: .preferredFont(forTextStyle: .headline))
        lbl.text = "Estúdio de Gravação Gleb Wataghin"
        lbl.textColor = .white
        lbl.numberOfLines = 0
        lbl.translatesAutoresizingMaskIntoConstraints = false
        return lbl
    }()
    
    
    func commonInit() {
        
        let gradient = GradientView()
        
        containerView.addSubview(imageView)
        containerView.addSubview(gradient)
        containerView.addSubview(title)
        
        imageView.setupConstraints(to: containerView)
        gradient.setupConstraints(to: containerView)
        
        containerView.layer.cornerRadius = 10
        containerView.layer.masksToBounds = true
        contentView.addSubview(containerView)
        
        title.leadingAnchor.constraint(equalTo: containerView.leadingAnchor, constant: 16).isActive = true
        title.widthAnchor.constraint(equalTo: containerView.widthAnchor, multiplier: 0.85).isActive = true
        title.topAnchor.constraint(equalTo: containerView.topAnchor, constant: 16).isActive = true
        
        containerView.setupConstraints(to: contentView)


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
