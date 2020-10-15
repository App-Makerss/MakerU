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
        title.font = UIFont.preferredFont(forTextStyle: .title3)
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

    let cardTitleDescription: UILabel = {
        let description = UILabel()
        description.font = UIFont.preferredFont(forTextStyle: .headline)
        description.text = "Descrição"
        return description
    }()

    let seeMoreButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setTitle("Ver Tudo", for: .normal)
        btn.tintColor = .systemPurple
        return btn
    }()

    let cardDescription: UILabel = {
        let description = UILabel()
        description.font = UIFont.preferredFont(forTextStyle: .callout)
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene..."
        description.numberOfLines = 6
        return description
    }()


    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    func downStack() -> UIStackView {
        let downStack = UIStackView(arrangedSubviews: [cardSubtitle, shareButton])
        downStack.distribution = .fillProportionally
        return downStack
    }

    func upStack() -> UIStackView {
        let upStack = UIStackView(arrangedSubviews: [cardTitle, downStack()])
        upStack.axis = .vertical
        upStack.spacing = 8
        return upStack
    }


    func commonInit(){
        let headerHStack: UIStackView = {
            let view = UIView()
            view.addSubview(cardImageView)
            cardImageView.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            cardImageView.centerYAnchor.constraint(equalTo: view.centerYAnchor).isActive = true
            view.translatesAutoresizingMaskIntoConstraints = false
            view.heightAnchor.constraint(equalToConstant: 75).isActive = true
            view.widthAnchor.constraint(equalToConstant: 75).isActive = true
            view.backgroundColor = .purple
            view.layer.cornerRadius = 10
            let rootView = UIStackView(arrangedSubviews: [view, upStack()])
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
