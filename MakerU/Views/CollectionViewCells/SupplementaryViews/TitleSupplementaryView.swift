//
//  TitleSupplementaryView.swift
//  MakerU
//
//  Created by Bruno Cardoso Ambrosio on 26/10/20.
//

import Foundation
import UIKit

final class TitleSupplementaryView: UICollectionReusableView {
    static let reuseIdentifier = String(describing: TitleSupplementaryView.self)
    
    let textLabel = UILabel()
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) is not implemented")
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        configure()
    }
    
    private func configure() {
        addSubview(textLabel)
        
        textLabel.setDynamicType(font: .systemFont(style: .title3, weight: .bold), textStyle: .title3)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.centerYAnchor.constraint(equalTo: centerYAnchor, constant: 1)
        ])
    }
    
}
