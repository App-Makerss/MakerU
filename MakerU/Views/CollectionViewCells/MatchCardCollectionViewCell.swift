//
//  MatchCardCollectionViewCell.swift
//  MakerU
//
//  Created by Victoria Faria on 14/10/20.
//

import UIKit

class MatchCardCollectionViewCell: UICollectionViewCell {

    let cardImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 34).isActive = true
        img.widthAnchor.constraint(equalToConstant: 40).isActive = true
        img.image = UIImage(systemName: "desktopcomputer")
        img.tintColor = .white
        return img
    }()

    let cardTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .title2)
        title.text = "Realidade aumentada para inclusão"
        title.numberOfLines = 0
        title.setContentCompressionResistancePriority(.init(rawValue: 1000), for: .vertical)
        return title
    }()

    let cardSubtitle: UILabel = {
        let subtitle = UILabel()
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.text = "Tecnologia"
        return subtitle
    }()

    let shareButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = .systemPurple
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func commonInit(){
        let headerHStack: UIStackView = {
            let downStack = UIStackView(arrangedSubviews: [cardSubtitle, shareButton])
            downStack.distribution = .fillProportionally
            let upStack = UIStackView(arrangedSubviews: [cardTitle, downStack])
            upStack.axis = .vertical
            upStack.spacing = 8
            let view = UIView()
            view.addSubview(cardImageView)
            cardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            cardImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 75).isActive = true
            view.widthAnchor.constraint(equalToConstant: 75).isActive = true
            view.backgroundColor = .purple
            view.layer.cornerRadius = 10
            let rootView = UIStackView(arrangedSubviews: [view, upStack])
            rootView.translatesAutoresizingMaskIntoConstraints = false
            rootView.alignment = .center
            rootView.spacing = 16

            return rootView
        }()

        contentView.addSubview(headerHStack)
        self.layer.cornerRadius = 10
        headerHStack.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        headerHStack.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
        headerHStack.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
        headerHStack.heightAnchor.constraint(equalToConstant: 122).isActive = true
    }
}
