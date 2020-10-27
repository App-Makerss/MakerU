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
    
    var showsTopDivider: Bool = false {
        didSet {
            divider.backgroundColor = showsTopDivider ? .systemGray3 : .clear
        }
    }
    let divider = UIView()
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
        addSubview(divider)
        divider.translatesAutoresizingMaskIntoConstraints = false

        textLabel.setDynamicType(font: .systemFont(style: .title3, weight: .bold), textStyle: .title3)
        textLabel.translatesAutoresizingMaskIntoConstraints = false
        
        
        NSLayoutConstraint.activate([
            divider.topAnchor.constraint(equalTo: topAnchor),
            divider.heightAnchor.constraint(equalToConstant: 0.5),
            divider.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 1),
            textLabel.leadingAnchor.constraint(equalTo: leadingAnchor),
            textLabel.trailingAnchor.constraint(equalTo: trailingAnchor),
            textLabel.topAnchor.constraint(equalTo: divider.bottomAnchor, constant: 16)
        ])
    }
    
}
