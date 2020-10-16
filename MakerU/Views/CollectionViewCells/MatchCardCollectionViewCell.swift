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
        img.heightAnchor.constraint(equalToConstant: 75).isActive = true
        img.widthAnchor.constraint(equalToConstant: 75).isActive = true
        img.image = UIImage(systemName: "desktopcomputer")
        img.tintColor = .purple
        img.layer.cornerRadius = 10
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
        subtitle.setContentHuggingPriority(.init(251), for: .vertical)
        subtitle.setContentHuggingPriority(.init(251), for: .horizontal)
        subtitle.font = UIFont.preferredFont(forTextStyle: .subheadline)
        subtitle.text = "Tecnologia"
        return subtitle
    }()

    let shareButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.setImage(UIImage(systemName: "square.and.arrow.up"), for: .normal)
        btn.tintColor = .systemPurple
        btn.contentHorizontalAlignment = .right
        return btn
    }()

    let cardFirstSessionTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.text = "Descrição"
        title.tintColor = .label
        return title
    }()

    let seeMoreButton: UIButton = {
        let btn = UIButton(type: .custom)
        btn.titleLabel?.font = UIFont.preferredFont(forTextStyle: .subheadline)
        btn.setTitle("Ver tudo", for: .normal)
        btn.setTitleColor(.systemPurple, for: .normal)
        btn.setContentCompressionResistancePriority(.init(1000), for: .horizontal)
        btn.contentHorizontalAlignment = .right
        return btn
    }()

    let cardFirstSessionDescription: UILabel = {
        let description = UILabel()
        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.font = UIFont.preferredFont(forTextStyle: .callout)
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene"
        description.numberOfLines = 6
        return description
    }()

    let cardSecondSessionTitle: UILabel = {
        let title = UILabel()
        title.font = UIFont.preferredFont(forTextStyle: .headline)
        title.text = "Habilidades Procuradas"
        title.tintColor = .label
        return title
    }()

    let cardSecondSessionDescription: UILabel = {
        let description = UILabel()
        description.setContentCompressionResistancePriority(.init(1000), for: .vertical)
        description.font = UIFont.preferredFont(forTextStyle: .callout)
        description.text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Euismod a, eget massa tristique. Interdum in eget tellus ut suspendisse viverra lectus placerat. Nibh id pulvinar orci, luctus sit turpis. Iorene"
        description.numberOfLines = 6
        return description
    }()

    let spacer: UIView = {
        let spa = UIView()
        spa.translatesAutoresizingMaskIntoConstraints = false
        spa.heightAnchor.constraint(equalToConstant: 39).isActive = true
        return spa
    }()

    let arrowImageView: UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.heightAnchor.constraint(equalToConstant: 24).isActive = true
        img.widthAnchor.constraint(equalToConstant: 26).isActive = true
        img.image = UIImage(systemName: "chevron.up.circle.fill")
        img.tintColor = .black
        return img
    }()

    let colaborateLabel: UILabel = {
        let label = UILabel()
        label.font = UIFont.preferredFont(forTextStyle: .caption2)
        label.text = "Vamos Colaborar?"
        label.tintColor = .label
        return label
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func headerContentStack() -> UIStackView {

        let downStack = UIStackView(arrangedSubviews: [cardSubtitle, shareButton])
        downStack.distribution = .fillProportionally

        let upStack = UIStackView(arrangedSubviews: [cardTitle, downStack])
        upStack.axis = .vertical
        upStack.spacing = 8

        let headerContent = UIStackView(arrangedSubviews: [cardImageView, upStack])
        headerContent.alignment = .center
        headerContent.spacing = 16
        return headerContent
    }

    private func firstSessionStack() -> UIStackView {

        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.backgroundColor = .lightGray

        let upStack = UIStackView(arrangedSubviews: [cardFirstSessionTitle, seeMoreButton])
        upStack.distribution = .fillProportionally

        let content = UIStackView(arrangedSubviews: [upStack, cardFirstSessionDescription])
        content.spacing = 8
        content.axis = .vertical

        let firstSessionStack = UIStackView(arrangedSubviews: [content])
        firstSessionStack.spacing = 20

        return firstSessionStack
    }

    private func secondSessionStack() -> UIStackView {

        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.backgroundColor = .lightGray

        let content = UIStackView(arrangedSubviews: [cardSecondSessionTitle, cardFirstSessionDescription])
        content.spacing = 8
        content.axis = .vertical

        return content
    }


    private func headerStack() -> UIStackView {

        let divider = UIView()
        divider.translatesAutoresizingMaskIntoConstraints = false
        divider.heightAnchor.constraint(equalToConstant: 1).isActive = true
        divider.backgroundColor = .lightGray

        let headerStack = UIStackView(arrangedSubviews: [headerContentStack(), divider])
        headerStack.axis = .vertical
        headerStack.spacing = 8
        return headerStack
    }

    func commonInit(){

        let root = UIStackView(arrangedSubviews: [headerStack(), firstSessionStack()])
        root.axis = .vertical
        root.spacing = 16
        root.distribution = .fillProportionally

        root.translatesAutoresizingMaskIntoConstraints = false
        contentView.addSubview(root)

        self.layer.cornerRadius = 10
        root.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 24).isActive = true
        root.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -24).isActive = true
        root.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 24).isActive = true
    }
}
